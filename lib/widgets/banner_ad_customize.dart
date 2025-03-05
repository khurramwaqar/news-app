import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wordpress_app/config/ad_config.dart';
import 'package:wordpress_app/config/config.dart';

class BannerAdCustomizeWidget extends StatefulWidget {
  final String adSize;
  final String adUnit;
  const BannerAdCustomizeWidget(
      {super.key, required this.adSize, required this.adUnit});

  @override
  State<StatefulWidget> createState() => BannerAdCustomizeState();
}

AdSize getSize(String adSize) {
  switch (adSize) {
    case 'LARGE_BANNER':
      return AdSize.largeBanner;
    case 'MEDIUM_RECTANGLE':
      return AdSize.mediumRectangle;
    case 'BANNER':
      return AdSize.banner;
    default:
      return AdSize.banner;
  }
}

class BannerAdCustomizeState extends State<BannerAdCustomizeWidget> {
  late BannerAd _bannerAd;
  final Completer<BannerAd> bannerCompleter = Completer<BannerAd>();

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: widget.adUnit,
      request: const AdRequest(),
      size: getSize(widget.adSize),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$BannerAd loaded.');
          bannerCompleter.complete(ad as BannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('$BannerAd failedToLoad: $error');
          bannerCompleter.completeError(error);
        },
        onAdOpened: (Ad ad) => debugPrint('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => debugPrint('$BannerAd onAdClosed.'),
        onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
      ),
    );
    Future<void>.delayed(const Duration(seconds: 1), () => _bannerAd.load());
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BannerAd>(
      future: bannerCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<BannerAd> snapshot) {
        Widget? child;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            child = Container();
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              child = AdWidget(ad: _bannerAd);
            } else {
              child = Text('Error loading $BannerAd');
            }
        }

        return Container(
          width: _bannerAd.size.width.toDouble(),
          height: _bannerAd.size.height.toDouble(),
          color: Colors.blueGrey,
          child: child,
        );
      },
    );
  }
}
