import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:wordpress_app/blocs/ads_banner.dart';
import 'package:wordpress_app/blocs/ads_bloc.dart';
import 'package:wordpress_app/blocs/category_bloc.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/blocs/settings_bloc.dart';
import 'package:wordpress_app/blocs/sidemenu_bloc.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/config/ad_config.dart';
import 'package:wordpress_app/services/notification_service.dart';
import 'package:wordpress_app/tabs/home_tab.dart';
import 'package:wordpress_app/tabs/home_tab_without_tabs.dart';
import 'package:wordpress_app/tabs/profile_tab.dart';
import 'package:wordpress_app/tabs/programs_tab.dart';
import 'package:wordpress_app/tabs/search_tab.dart';
import 'package:wordpress_app/widgets/banner_ad_customize.dart';
import '../blocs/featured_bloc.dart';
import '../blocs/latest_articles_bloc.dart';
import '../blocs/notification_bloc.dart';
import '../blocs/popular_articles_bloc.dart';
import '../services/app_links_service.dart';
import '../tabs/bookmark_tab.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart'; // For combining streams

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController? _pageController;

  // Miniplayer controller for programmatic expand/collapse if desired
  final MiniplayerController _miniPlayerController = MiniplayerController();

  // Just_audio player instance
  late AudioPlayer _audioPlayer;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (Duration position, Duration bufferedPosition, Duration? duration) {
          return PositionData(
            position,
            bufferedPosition,
            duration ?? Duration.zero,
          );
        },
      );

  // Example live stream URL (replace with your own)
  final String _streamUrl =
      'https://arynewsm.aryzap.com/v1/0183ea205add0b8ed5941a38bc6f/018ad63928611ea50695040da296/main.m3u8';

  final List<IconData> _iconList = [
    Feather.home,
    Feather.search,
    Feather.heart,
    Feather.user
  ];

  final List<IconData> _iconListWithVideoTab = [
    Feather.home,
    Feather.youtube,
    Feather.search,
    Feather.heart,
    Feather.user
  ];

  final List<Widget> _tabs = [
    const SearchTab(),
    const BookmarkTab(),
    const SettingPage(),
  ];

  final List<Widget> _tabsWithVideo = [
    const ProgramsTab(),
    const SearchTab(),
    const BookmarkTab(),
    const SettingPage()
  ];

  void _initData() async {
    final smb = context.read<SidemennuBloc>();
    final adm = context.read<AdsManagerBloc>();
    final cb = context.read<CategoryBloc>();
    final nb = context.read<NotificationBloc>();
    final ab = context.read<AdsBloc>();
    final ub = context.read<UserBloc>();
    final sb = context.read<SettingsBloc>();
    final configs = context.read<ConfigBloc>().configs!;

    NotificationService().initOneSignal(context);
    Future.microtask(() {
      nb.checkPermission();
      cb.fetchData(configs.blockedCategories);
      smb.fetchData();
      adm.fetchData();
    });

    await AppLinksService().initUniLinks(context);
    sb.getPackageInfo();

    if (!ub.guestUser) {
      ub.getUserData();
    }
    if (configs.admobEnabled) {
      await AdConfig.initAdmob().then((value) {
        if (configs.interstitialAdsEnabled) {
          ab.initiateAds();
        }
      });
    }
  }

  _fetchPostsData() async {
    Future.microtask(() {
      if (!mounted) return;
      final configs = context.read<ConfigBloc>().configs!;
      if (configs.featuredPostEnabled) {
        context.read<FeaturedBloc>().fetchData();
      }
      if (configs.popularPostEnabled) {
        context.read<PopularArticlesBloc>().fetchData();
      }
      context.read<LatestArticlesBloc>().fetchData(configs.blockedCategories);
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initData();
    _fetchPostsData();
    _audioPlayer = AudioPlayer();
    // Prepare audio stream right away (or trigger it on a button press)
    _initAudio();
  }

  // Example method to initialize live audio playback
  Future<void> _initAudio() async {
    try {
      // Load the streaming URL; you can handle playback after user input if desired
      await _audioPlayer.setUrl(_streamUrl);
      // Autoplay (optional)
      // _audioPlayer.play();
    } catch (e) {
      debugPrint('Error loading audio stream: $e');
    }
  }

  @override
  void dispose() {
    _pageController!.dispose();
    _audioPlayer.dispose(); // very important to release resources

    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController!.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  Future _onBackPressed() async {
    if (_selectedIndex != 0) {
      setState(() => _selectedIndex = 0);
      _pageController!.animateToPage(0,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    } else {
      await SystemChannels.platform
          .invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  void _togglePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cb = context.read<ConfigBloc>();
    return PopScope(
      child: Scaffold(
        bottomNavigationBar: _bottonNavigationBar(context, cb),
        body: Stack(
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              allowImplicitScrolling: false,
              controller: _pageController,
              children: <Widget>[
                cb.configs!.homeCategories.isEmpty
                    ? HomeTabWithoutTabs(
                        configs: cb.configs!,
                      )
                    : HomeTab(
                        configs: cb.configs!,
                        homeCategories: cb.homeCategories,
                        categoryTabs: _categoryTabs(cb),
                      ),
                ..._childrens(cb),
                // Miniplayer pinned to bottom; we give it a small margin so it's clearly above the bottom nav
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 0, // bottom nav’s height; adjust to your UI
                ),
                child: StreamBuilder<PlayerState>(
                  stream: _audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final isPlaying = playerState?.playing ?? false;
                    return Miniplayer(
                      controller: _miniPlayerController,
                      minHeight: 95,
                      maxHeight: 95,
                      builder: (height, percentage) {
                        return Container(
                          color: Theme.of(context).cardColor,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: Icon(
                                  //     FontAwesome.podcast,
                                  //     size: 32,
                                  //     color: isPlaying
                                  //         ? Colors.red.shade900
                                  //         : Colors.grey.shade600,
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      trailing: IconButton(
                                          icon: isPlaying
                                              ? Icon(
                                                  FontAwesome.pause,
                                                  size: 24,
                                                  color: Colors.red.shade900,
                                                )
                                              : Icon(
                                                  FontAwesome.play,
                                                  size: 24,
                                                  color: Colors.grey.shade400,
                                                ),
                                          onPressed: () {
                                            _togglePlayPause();
                                          }),
                                      leading: IconButton(
                                        icon: Icon(
                                          FontAwesome.podcast,
                                          size: 32,
                                          color: isPlaying
                                              ? Colors.red.shade900
                                              : Colors.grey.shade600,
                                        ),
                                        onPressed: () {
                                          _togglePlayPause();
                                        },
                                      ),
                                      title: Text(
                                        'ARY News',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        'Audio Live Stream',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              StreamBuilder<PositionData>(
                                stream: _positionDataStream,
                                builder: (context, snapshot) {
                                  final positionData = snapshot.data;
                                  final duration =
                                      positionData?.duration ?? Duration.zero;
                                  final position =
                                      positionData?.position ?? Duration.zero;
                                  final buffered =
                                      positionData?.bufferedPosition ??
                                          Duration.zero;
                                  return Column(
                                    children: [
                                      LinearProgressIndicator(
                                        value: (buffered.inMilliseconds /
                                                (duration.inMilliseconds == 0
                                                    ? 1
                                                    : duration.inMilliseconds))
                                            .clamp(0, 1),
                                        backgroundColor: Colors.grey.shade300,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              StreamBuilder<PositionData>(
                                stream: _positionDataStream,
                                builder: (context, snapshot) {
                                  final positionData = snapshot.data;
                                  final duration =
                                      positionData?.duration ?? Duration.zero;
                                  final position =
                                      positionData?.position ?? Duration.zero;
                                  final buffered =
                                      positionData?.bufferedPosition ??
                                          Duration.zero;

                                  // If this is purely live (no seeking available),
                                  // you might want to hide this Slider or just show a loading bar.
                                  return Column(
                                    children: [
                                      LinearProgressIndicator(
                                        minHeight: 1.5,
                                        value: (buffered.inMilliseconds /
                                                (duration.inMilliseconds == 0
                                                    ? 1
                                                    : duration.inMilliseconds))
                                            .clamp(0, 1),
                                        backgroundColor: Colors.grey.shade300,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _childrens(ConfigBloc cb) {
    if (cb.configs!.videoTabEnabled) {
      return _tabsWithVideo;
    } else {
      return _tabs;
    }
  }

  List<Tab> _categoryTabs(ConfigBloc cb) {
    return cb.homeCategories.map((e) => Tab(text: e.name)).toList()
      ..insert(0, Tab(text: 'explore'.tr()));
  }

  AnimatedBottomNavigationBar _bottonNavigationBar(
      BuildContext context, ConfigBloc cb) {
    return AnimatedBottomNavigationBar(
      icons: cb.configs!.videoTabEnabled ? _iconListWithVideoTab : _iconList,
      gapLocation: GapLocation.none,
      activeIndex: _selectedIndex,
      iconSize: 22,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      inactiveColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      splashColor: Theme.of(context).primaryColor,
      onTap: (index) => onItemTapped(index),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  const PositionData(this.position, this.bufferedPosition, this.duration);
}
