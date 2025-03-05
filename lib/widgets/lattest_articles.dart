import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wordpress_app/blocs/ads_banner.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/cards/card6.dart';
import 'package:wordpress_app/cards/card4.dart';
import 'package:wordpress_app/config/ad_config.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/utils/vertical_line.dart';
import 'package:wordpress_app/widgets/banner_ad_customize.dart';
import 'package:wordpress_app/widgets/inline_ads.dart';
import '../blocs/latest_articles_bloc.dart';
import 'loading_indicator_widget.dart';

class LattestArticles extends StatefulWidget {
  const LattestArticles({super.key});

  @override
  State<LattestArticles> createState() => _LattestArticlesState();
}

class _LattestArticlesState extends State<LattestArticles> {
  @override
  Widget build(BuildContext context) {
    final articles = context.watch<LatestArticlesBloc>().articles;
    final configs = context.read<ConfigBloc>().configs!;
    final getAdInfo = context.read<AdsManagerBloc>().adManagerData!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 20,
          ),
          child: Row(
            children: [
              verticalLine(context, 22.0),
              const SizedBox(
                width: 5,
              ),
              const Text('recent-contents',
                      style: TextStyle(
                          letterSpacing: -0.7,
                          wordSpacing: 1,
                          fontWeight: FontWeight.w700,
                          fontSize: 20))
                  .tr(),
            ],
          ),
        ),
        articles.isEmpty
            ? Container()
            : ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(15),
                shrinkWrap: true,
                itemCount: articles.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 15,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Article article = articles[index];
                  if ((index + 1) % configs.postIntervalCount == 0) {
                    return Column(
                      children: [
                        Card6(
                            article: article, heroTag: UniqueKey().toString()),
                        getAdInfo.iosMeta?.iosCategoryFirstStatus == true
                            ? BannerAdCustomizeWidget(
                                adSize:
                                    getAdInfo.iosMeta!.iosCategoryFirstAdsize!,
                                adUnit:
                                    getAdInfo.iosMeta!.iosCategoryFirstAdUnit!,
                              )
                            : const SizedBox(
                                height: 1,
                              )
                      ],
                    );
                  } else {
                    return Card4(
                        article: article, heroTag: UniqueKey().toString());
                  }
                },
              ),
        Opacity(
          opacity:
              context.watch<LatestArticlesBloc>().loading == true ? 1.0 : 0.0,
          child: const LoadingIndicatorWidget(),
        ),
      ],
    );
  }
}
