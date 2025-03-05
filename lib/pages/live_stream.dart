import 'dart:async';
import 'package:flutter/material.dart';
import 'package:interactive_media_ads/interactive_media_ads.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/ads_banner.dart';
import 'package:wordpress_app/services/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';

class LiveStream extends StatefulWidget {
  final String? iosLiveStreamStream;
  final String? iosLiveStreamAdUrl;
  const LiveStream({super.key, this.iosLiveStreamStream, this.iosLiveStreamAdUrl});

  @override
  _LiveStreamState createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> with WidgetsBindingObserver {

  late final PodPlayerController controller;

  Future<void> initializePlayer() async {}


  static const String _adTagUrl =
      'https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/single_preroll_skippable&sz=640x480&ciu_szs=300x250%2C728x90&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator=';
  late final AdsLoader _adsLoader;
  AdsManager? _adsManager;
  bool _shouldShowContentVideo = true;
  late final VideoPlayerController _contentVideoController;
  late final AdDisplayContainer _adDisplayContainer = AdDisplayContainer(
    onContainerAdded: (AdDisplayContainer container) {
      // Ads can't be requested until the `AdDisplayContainer` has been added to
      // the native View hierarchy.
      _requestAds(container);
    },
  );



  @override
  void initState() {
    if(widget!.iosLiveStreamStream != null){
      controller = PodPlayerController(
          playVideoFrom: PlayVideoFrom.network(
            "https://arynewsm.aryzap.com/v1/0183ea205add0b8ed5941a38bc6f/018ad63928611ea50695040da296/main.m3u8",
          )
      )..addListener(() {
        if (controller.isVideoPlaying) {
          _adsLoader.contentComplete();
          setState(() {});
        }
      })
        ..initialise().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

          setState(() {});
        });
    }


    super.initState();
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
    controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Streaming...').tr(),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: (){},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(right: 15, left: 15),
            ),
            child: const Text('clear-all').tr(),
          ),
        ],
      ),
      body: Column(
        children: [
        Center(
          child: AspectRatio(
            aspectRatio: 16/9,
            child: !controller.isInitialised
                ? Container()
                : AspectRatio(
                    aspectRatio: 16/9,
                    child: Stack(
                      children: [
                        _adDisplayContainer,
                        if (_shouldShowContentVideo)
                          PodVideoPlayer(controller: controller)
                      ],
                    ),
                  ),
          ),),
          Text("Hello world!")
        ],
      ),
    );
  }
}