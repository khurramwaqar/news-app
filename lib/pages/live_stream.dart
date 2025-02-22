import 'dart:async';

import 'package:flutter/material.dart';
import 'package:interactive_media_ads/interactive_media_ads.dart';
import 'package:pod_player/pod_player.dart';
import 'package:wordpress_app/services/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';

class LiveStream extends StatefulWidget {
  const LiveStream({super.key});

  @override
  _LiveStreamState createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> with WidgetsBindingObserver {
  late final PodPlayerController controller;
  static const String _adTagUrl =
      'https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/single_preroll_skippable&sz=640x480&ciu_szs=300x250%2C728x90&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator=';
  late final AdsLoader _adsLoader;
  AdsManager? _adsManager;
  bool _shouldShowContentVideo = true;
  late final VideoPlayerController _contentVideoController;
  Timer? _contentProgressTimer;

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

    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(
        'https://arynewsm.aryzap.com/v1/0183ea205add0b8ed5941a38bc6f/018ad63928611ea50695040da296/main.m3u8',
      ),
    )..initialise();

    _contentVideoController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://arynewsm.aryzap.com/v1/0183ea205add0b8ed5941a38bc6f/018ad63928611ea50695040da296/main.m3u8',
      ),
    )
      ..addListener(() {
        if (controller.isMute) {
          _adsLoader.contentComplete();
          setState(() {});
        }
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
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

  void _resumeContent() {
    setState(() {
      _shouldShowContentVideo = true;
    });
    return controller.play();
  }

  void _pauseContent() {
    setState(() {
      _shouldShowContentVideo = false;
    });
    return controller.pause();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
        title: const Text('Live Streaming...').tr(),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: double.infinity,
              child: !_contentVideoController.value.isInitialized
                  ? Container()
                  : AspectRatio(
                      aspectRatio: _contentVideoController.value.aspectRatio,
                      child: Stack(
                        children: [
                          // The display container must be on screen before any Ads can be
                          // loaded and can't be removed between ads. This handles clicks for
                          // ads.
                          _adDisplayContainer,
                          if (_shouldShowContentVideo)
                            //VideoPlayer(_contentVideoController)
                            PodVideoPlayer(controller: controller),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
