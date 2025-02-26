import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart'; // For combining streams
import 'package:wordpress_app/services/notification_service.dart';

class LiveStreamAudio extends StatefulWidget {
  const LiveStreamAudio({Key? key}) : super(key: key);

  @override
  State<LiveStreamAudio> createState() => _LiveStreamAudioState();
}

class _LiveStreamAudioState extends State<LiveStreamAudio> {
  late AudioPlayer _player;

  // A combined stream that emits the current position, buffered position, and total duration
  // This helps us manage the Slider position and buffering UI
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (Duration position, Duration bufferedPosition, Duration? duration) {
          return PositionData(
            position,
            bufferedPosition,
            duration ?? Duration.zero,
          );
        },
      );

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    // Load the live-stream source.
    await _player.setUrl(
      'https://arynewsm.aryzap.com/v1/0183ea205add0b8ed5941a38bc6f/018ad63928611ea50695040da296/main.m3u8',
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void openClearAllDialog() {
    showModalBottomSheet(
      elevation: 2,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: false,
      backgroundColor: Theme.of(context).canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 210,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Clear Notifications',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.6,
                  wordSpacing: 1,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      NotificationService().deleteAllNotificationData();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _togglePlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Streaming Audio'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: openClearAllDialog,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(right: 15, left: 15),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<PlayerState>(
          stream: _player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final isPlaying = playerState?.playing ?? false;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circular image or placeholder
                  const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/images/live_audio.jpg'),
                    // Or use NetworkImage if you have a URL
                    // backgroundImage: NetworkImage('https://example.com/myimage.jpg'),
                  ),
                  const SizedBox(height: 30),
                  // Position/SeekBar
                  // For a true live stream, seeking might not be supported
                  // but below is a demonstration of how to show a slider if desired.
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      final duration = positionData?.duration ?? Duration.zero;
                      final position = positionData?.position ?? Duration.zero;
                      final buffered =
                          positionData?.bufferedPosition ?? Duration.zero;

                      // If this is purely live (no seeking available),
                      // you might want to hide this Slider or just show a loading bar.
                      return Column(
                        children: [
                          LinearProgressIndicator(
                            value: (buffered.inMilliseconds /
                                    (duration.inMilliseconds == 0
                                        ? 1
                                        : duration.inMilliseconds))
                                .clamp(0, 1),
                            backgroundColor: Colors.red.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  // Play/Pause Button
                  FloatingActionButton(
                    onPressed: _togglePlayPause,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A simple data class to hold position, buffered position, and duration
class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  const PositionData(this.position, this.bufferedPosition, this.duration);
}
