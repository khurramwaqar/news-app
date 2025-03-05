import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:interactive_media_ads/interactive_media_ads.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/ads_banner.dart';
import 'package:wordpress_app/config/ad_config.dart';
import 'package:wordpress_app/models/app_config_model.dart';
import 'package:wordpress_app/models/category.dart';
import 'package:wordpress_app/pages/live_stream.dart';
import 'package:wordpress_app/pages/live_stream_audio.dart';
import 'package:wordpress_app/pages/notifications.dart';
import 'package:wordpress_app/pages/tag_based_articles_for_tools_widget.dart';
import 'package:wordpress_app/pages/webview_page.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/utils/service_tool_widget.dart';
import 'package:wordpress_app/widgets/app_logo.dart';
import 'package:wordpress_app/widgets/banner_ad.dart';
import 'package:wordpress_app/widgets/banner_ad_customize.dart';
import 'package:wordpress_app/widgets/drawer.dart';
import 'package:wordpress_app/widgets/tab_medium.dart';
import '../pages/search.dart';
import '../models/tools_widget.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    super.key,
    required this.configs,
    required this.categoryTabs,
    required this.homeCategories,
  });

  final List<Category> homeCategories;
  final ConfigModel configs;
  final List<Tab> categoryTabs;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
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

  late TabController _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<ToolsWidget>> _toolsWidget;

  @override
  void initState() {
    _tabController = TabController(
        length: widget.categoryTabs.length, initialIndex: 0, vsync: this);
    super.initState();
    _toolsWidget = ToolsWidgetService().fetchToolsWidget();

    _contentVideoController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://storage.googleapis.com/gvabox/media/samples/stock.mp4',
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
    _tabController.dispose();
    super.dispose();
    _contentVideoController.dispose();
    _adsManager?.destroy();
  }

  @override
  Widget build(BuildContext context) {
    final adm = context.watch<AdsManagerBloc>().adManagerData!;
    super.build(context);
    return Scaffold(
      drawer: Visibility(
          visible: widget.configs.menubarEnabled, child: const CustomDrawer()),
      key: scaffoldKey,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: widget.configs.logoPositionCenter,
              titleSpacing: 0,
              title: const AppLogo(
                height: 19,
              ),
              leading: Visibility(
                visible: widget.configs.menubarEnabled,
                child: IconButton(
                  icon: const Icon(
                    Feather.menu,
                    size: 25,
                  ),
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                ),
              ),
              elevation: 1,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    AntDesign.search1,
                    size: 22,
                  ),
                  onPressed: () {
                    nextScreenPopupiOS(context, const SearchPage());
                  },
                ),
                const SizedBox(width: 3),
                IconButton(
                  padding: const EdgeInsets.only(right: 8),
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    AntDesign.bells,
                    size: 20,
                  ),
                  onPressed: () =>
                      nextScreenPopupiOS(context, const Notifications()),
                ),
                IconButton(
                  padding: const EdgeInsets.only(right: 8),
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    FontAwesome5.play_circle,
                    size: 20,
                  ),
                  onPressed: () =>
                      nextScreenPopupiOS(context, LiveStream(iosLiveStreamStream: adm.iosMeta!.iosLiveStreamStream, iosLiveStreamAdUrl: adm.iosMeta!.iosLiveStreamAdUrl!)),
                ),
              ],
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                tabAlignment: TabAlignment.start,
                labelStyle: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor:
                    const Color.fromARGB(255, 70, 70, 70), //niceish grey
                isScrollable: true,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: widget.categoryTabs,
              ),
            ),
          ];
        },
        body: Column(
          children: [
            // Center(
            //   child: SizedBox(
            //     width: 300,
            //     child: !_contentVideoController.value.isInitialized
            //         ? Container()
            //         : AspectRatio(
            //             aspectRatio: _contentVideoController.value.aspectRatio,
            //             child: Stack(
            //               children: [
            //                 // The display container must be on screen before any Ads can be
            //                 // loaded and can't be removed between ads. This handles clicks for
            //                 // ads.
            //                 _adDisplayContainer,
            //                 if (_shouldShowContentVideo)
            //                   VideoPlayer(_contentVideoController)
            //               ],
            //             ),
            //           ),
            //   ),
            // ),
            // Add your Container here
            SizedBox(
              width: double.infinity,
              height: 42, // Adjust the height as needed
              child: FutureBuilder<List<ToolsWidget>>(
                future: _toolsWidget,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No tools found.'));
                  } else {
                    List<ToolsWidget> tools = snapshot.data!;
                    return ListView.builder(
                      scrollDirection:
                          Axis.horizontal, // Set scroll direction to horizontal
                      shrinkWrap: true,
                      itemCount: tools.length,
                      itemBuilder: (context, index) {
                        return Container(
                          // Set a fixed width for each item
                          margin: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              tools[index].action == "tag"
                                  ? nextScreenPopupiOS(
                                      context,
                                      TagBasedArticlesForToolsAndWidget(
                                          tag: tools[index]))
                                  : nextScreenPopupCustomiOS(context,
                                      WebViewPage(toolsWidget: tools[index]));
                              print('${tools[index].title} icon tapped');
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (tools[index].iconF == null)
                                  Image.network(
                                    tools[index].icon!,
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.cover,
                                  ),
                                if (tools[index].iconF == "stock")
                                  const Icon(
                                    Foundation.graph_bar,
                                    size: 20,
                                  ),
                                if (tools[index].iconF == "gold")
                                  const Icon(
                                    Foundation.ticket,
                                    size: 20,
                                  ),
                                if (tools[index].iconF == "currency")
                                  const Icon(
                                    Foundation.dollar,
                                    size: 20,
                                  ),
                                if (tools[index].iconF == "pray")
                                  const Icon(
                                    AntDesign.bank,
                                    size: 20,
                                  ),
                                const SizedBox(width: 8.0),
                                Text(
                                  tools[index].title ?? 'No Title',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Manrope',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            Expanded(
              child: Builder(
                builder: (BuildContext context) {
                  final ScrollController innerScrollController =
                      PrimaryScrollController.of(context);
                  return TabMedium(
                    sc: innerScrollController,
                    tc: _tabController,
                    scaffoldKey: scaffoldKey,
                    homeCategories: widget.homeCategories,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton:
      //     _contentVideoController.value.isInitialized && _shouldShowContentVideo
      //         ? FloatingActionButton(
      //             onPressed: () {
      //               setState(() {
      //                 _contentVideoController.value.isPlaying
      //                     ? _contentVideoController.pause()
      //                     : _contentVideoController.play();
      //               });
      //             },
      //             child: Icon(
      //               _contentVideoController.value.isPlaying
      //                   ? Icons.pause
      //                   : Icons.play_arrow,
      //             ),
      //           )
      //         : null,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
