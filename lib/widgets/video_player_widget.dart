import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget(
      {super.key,
      required this.videoUrl,
      required this.videoType,
      this.thumbnailUrl});
  final String videoUrl;
  final String videoType;
  final String? thumbnailUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final PodPlayerController controller;

  // @override
  // void initState() {
  //   controller = PodPlayerController(
  //       playVideoFrom: widget.videoType == 'network'
  //           ? PlayVideoFrom.network(widget.videoUrl)
  //           : widget.videoType == 'vimeo'
  //               ? PlayVideoFrom.vimeo(widget.videoUrl)
  //               : PlayVideoFrom.youtube(widget.videoUrl),
  //       podPlayerConfig: const PodPlayerConfig(
  //         autoPlay: false,
  //         isLooping: false,
  //       ))
  //     ..initialise();
  //   super.initState();
  // }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoId = extractYouTubeId(widget.videoUrl.toString()) ?? "";
    return YoutubePlayer(
      controller: YoutubePlayerController.fromVideoId(
        videoId: videoId,
        params: const YoutubePlayerParams(
          mute: false,
          showControls: true,
          showFullscreenButton: true,
        ),
      ),
      aspectRatio: 16 / 9,
    );
    // return PodVideoPlayer(
    //   controller: controller,
    //   alwaysShowProgressBar: true,
    //   videoThumbnail: widget.thumbnailUrl == null
    //       ? null
    //       : DecorationImage(
    //           fit: BoxFit.cover,
    //           image: CachedNetworkImageProvider(widget.thumbnailUrl!),
    //         ),
    // );
  }
}

String? extractYouTubeId(String url) {
  final uri = Uri.parse(url);

  // Check for the standard "watch?v=" format.
  if (uri.host.contains('youtube.com')) {
    // e.g. https://www.youtube.com/watch?v=A2h9Fe9YN70
    // The video ID is in the 'v' query parameter.
    final videoId = uri.queryParameters['v'];
    if (videoId != null) {
      return videoId;
    }

    // Check for embed links: https://www.youtube.com/embed/A2h9Fe9YN70?feature=oembed
    // The path segment immediately after 'embed' should be the video ID.
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'embed') {
      // e.g. pathSegments = ['embed','A2h9Fe9YN70']
      if (uri.pathSegments.length > 1) {
        return uri.pathSegments[1];
      }
    }
  }

  // Check for the shortened youtu.be format.
  // e.g. https://youtu.be/kxhnz_aacWU
  if (uri.host.contains('youtu.be')) {
    // The video ID is the first path segment
    if (uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.first;
    }
  }

  // If no pattern matched, return null.
  return null;
}
