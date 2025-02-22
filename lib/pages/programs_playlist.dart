import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interactive_media_ads/interactive_media_ads.dart';
import 'package:pod_player/pod_player.dart';
import 'package:wordpress_app/cards/custom_notification_card.dart';
import 'package:wordpress_app/cards/post_notification_card.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/notification_model.dart';
import 'package:wordpress_app/models/programs_playlist.dart';
import 'package:wordpress_app/pages/single_programs.dart';
import 'package:wordpress_app/services/notification_service.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import '../utils/next_screen.dart';
import '../constants/constant.dart';

class ProgramsPlaylist extends StatefulWidget {
  final String episode;
  final String episodeTitle;
  const ProgramsPlaylist(
      {super.key, required this.episode, required this.episodeTitle});

  @override
  _ProgramsPlaylistState createState() => _ProgramsPlaylistState();
}

class _ProgramsPlaylistState extends State<ProgramsPlaylist> {
  static const String _adTagUrl =
      'https://pubads.g.doubleclick.net/gampad/live/ads?iu=/67551462/ARYNews-Live_640x480&description_url=https%3A%2F%2Flive.arynews.tv&tfcd=0&npa=0&sz=176x144%7C320x180%7C352x288%7C375x210%7C400x300%7C640x360%7C640x480%7C854x480%7C1280x720&min_ad_duration=5000&max_ad_duration=120000&gdfp_req=1&unviewed_position_start=1&output=xml_vast4&env=vp&impl=s&correlator=&vad_type=linear&env=vp&impl=s&correlator=786&vpmute=0&vpa=auto&sid=0&ad_type=video';
  late final AdsLoader _adsLoader;
  AdsManager? _adsManager;
  bool _shouldShowContentVideo = true;
  late final VideoPlayerController _contentVideoController;
  late Future<ProgramsPlaylistModel> futureProgramsPlaylist;

  late final AdDisplayContainer _adDisplayContainer = AdDisplayContainer(
    onContainerAdded: (AdDisplayContainer container) {
      // Ads can't be requested until the `AdDisplayContainer` has been added to
      // the native View hierarchy.
      _requestAds(container);
    },
  );

  @override
  void initState() {
    super.initState();
    _contentVideoController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://arynewsm.aryzap.com/v1/0183ea205add0b8ed5941a38bc6f/018ad63928611ea50695040da296/main.m3u8',
      ),
    )
      ..addListener(() {
        if (_contentVideoController.value.isCompleted) {
          _adsLoader.contentComplete();
          setState(() {});
        }
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    futureProgramsPlaylist = fetchProgramsPlaylist(widget.episode);
  }

  Future<ProgramsPlaylistModel> fetchProgramsPlaylist(String id) async {
    final response = await http
        .get(Uri.parse('https://node.aryzap.com/api/yt/${id.toString()}'));

    if (response.statusCode == 200) {
      return programsPlaylistModelFromJson(response.body);
    } else {
      throw Exception('Failed to load programs playlist');
    }
  }

  Future<void> _requestAds(AdDisplayContainer container) {
    _adsLoader = AdsLoader(
      container: container,
      onAdsLoaded: (OnAdsLoadedData data) {
        final AdsManager manager = data.manager;
        _adsManager = data.manager;

        manager.setAdsManagerDelegate(AdsManagerDelegate(
          onAdEvent: (AdEvent event) {
            debugPrint('OnAdEvent: ${event.type} => ${event.adData}');
            switch (event.type) {
              case AdEventType.loaded:
                manager.start();
              case AdEventType.contentPauseRequested:
                _pauseContent();
              case AdEventType.contentResumeRequested:
                _resumeContent();
              case AdEventType.allAdsCompleted:
                manager.destroy();
                _adsManager = null;
              case AdEventType.clicked:
              case AdEventType.complete:
              case _:
            }
          },
          onAdErrorEvent: (AdErrorEvent event) {
            debugPrint('AdErrorEvent: ${event.error.message}');
            _resumeContent();
          },
        ));

        manager.init();
      },
      onAdsLoadError: (AdsLoadErrorData data) {
        debugPrint('OnAdsLoadError: ${data.error.message}');
        _resumeContent();
      },
    );

    return _adsLoader.requestAds(AdsRequest(adTagUrl: _adTagUrl));
  }

  Future<void> _resumeContent() {
    setState(() {
      _shouldShowContentVideo = true;
    });
    return _contentVideoController.play();
  }

  Future<void> _pauseContent() {
    setState(() {
      _shouldShowContentVideo = false;
    });
    return _contentVideoController.pause();
  }

  @override
  void dispose() {
    super.dispose();
    _contentVideoController.dispose();
    _adsManager?.destroy();
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
                'clear-notification-dialog',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    wordSpacing: 1),
              ).tr(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      backgroundColor: Theme.of(context).primaryColor,
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
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      backgroundColor: Colors.grey.shade400,
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
                          fontWeight: FontWeight.w600),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.episodeTitle.toString()),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: openClearAllDialog,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(right: 15, left: 15),
            ),
            child: const Text('clear-all').tr(),
          ),
        ],
      ),
      body: FutureBuilder<ProgramsPlaylistModel>(
        future: futureProgramsPlaylist,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.episode?.length ?? 0,
              itemBuilder: (context, index) {
                final episode = snapshot.data!.episode![index];
                return InkWell(
                  onTap: () => {
                    nextScreenPopupSingleProgram(
                        context, SingleProgram(episode: episode))
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                    child: Row(
                      children: [
                        episode.imagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/placeholder.jpg',
                                  image: episode.imagePath!,
                                  width: 120,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return const Icon(Icons
                                        .image); // Fallback icon if loading fails
                                  },
                                ),
                                // child: Image.network(
                                //   episode.imagePath!,
                                //   width: 120,
                                //   height: 70,
                                //   fit: BoxFit.cover,
                                // ),
                              )
                            : const Icon(Icons.image),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                          child: Text(
                            episode.title ?? 'No Title',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                      // leading: episode.imagePath != null
                      //     ? ClipRRect(
                      //         borderRadius: BorderRadius.circular(10.0),
                      //         child: Image.network(
                      //           episode.imagePath!,
                      //           width: 120,
                      //           height: 120,
                      //           fit: BoxFit.cover,
                      //         ),
                      //       )
                      //     : const Icon(Icons.image),
                      // title: Text(
                      //   episode.title ?? 'No Title',
                      //   overflow: TextOverflow.ellipsis,
                      //   maxLines: 2,
                      //   style: const TextStyle(
                      //       fontWeight: FontWeight.w900, fontSize: 18.0),
                      // ),
                      // //subtitle: Text(episode.description ?? 'No Description'),
                      // onTap: () {
                      //   // Handle tap event here, e.g., navigate to a detail page
                      // },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No episodes available'));
          }
        },
      ),
    );
  }
}
