import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/cards/sliver_card1.dart';
import 'package:wordpress_app/models/category.dart';
import 'package:wordpress_app/models/sidemenu.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:wordpress_app/utils/cached_image_with_dark.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/widgets/inline_ads.dart';
import 'package:wordpress_app/widgets/loading_indicator_widget.dart';
import '../models/article.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryBasedArticles extends StatefulWidget {
  final Category category;
  final String? heroTag;
  final bool? isManual;
  final Sidebar? sidebar;
  const CategoryBasedArticles(
      {super.key,
      this.isManual,
      this.heroTag,
      this.sidebar,
      required this.category});

  @override
  State<CategoryBasedArticles> createState() => _CategoryBasedArticlesState();
}

class _CategoryBasedArticlesState extends State<CategoryBasedArticles> {
  final List<Article> _articles = [];
  ScrollController? _controller;
  int page = 1;
  bool? _loading;
  bool? _hasData;
  final int _postAmount = 10;

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller!.addListener(_scrollListener);
    _fetchArticles();
    _hasData = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Future _fetchArticles() async {
    await WordPressService()
        .fetchPostsByCategoryId(
            widget.isManual == true ? widget.sidebar!.id : widget.category.id,
            page,
            _postAmount)
        .then((value) {
      _articles.addAll(value);
      if (_articles.isEmpty) {
        _hasData = false;
      }
      setState(() {});
    });
  }

  _scrollListener() async {
    var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange;
    if (isEnd && _articles.isNotEmpty) {
      setState(() {
        page += 1;
        _loading = true;
      });
      await _fetchArticles().then((_) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  Future _onRefresh() async {
    setState(() {
      _loading = null;
      _hasData = true;
      _articles.clear();
      page = 1;
    });
    await _fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    final configs = context.read<ConfigBloc>().configs!;
    return Scaffold(
      body: RefreshIndicator(
        child: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
              backgroundColor: Theme.of(context).primaryColor,
              expandedHeight: MediaQuery.of(context).size.height * 0.15,
              elevation: 0.5,
              flexibleSpace: _flexibleSpaceBar(),
            ),
            _hasData == false
                ? SliverFillRemaining(
                    child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.20,
                      ),
                      EmptyPageWithImage(
                          image: Config.noContentImage,
                          title: 'no-contents'.tr()),
                    ],
                  ))
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (_articles.isEmpty && _hasData == true) {
                            return Container(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: const LoadingCard(height: 250));
                          } else if (index < _articles.length) {
                            if ((index + 1) % configs.postIntervalCount == 0) {
                              return Column(
                                children: [
                                  SliverCard1(
                                      article: _articles[index],
                                      heroTag: UniqueKey().toString()),
                                  const InlineAds(isSliver: true),
                                ],
                              );
                            } else {
                              return SliverCard1(
                                  article: _articles[index],
                                  heroTag: UniqueKey().toString());
                            }
                          }

                          return Opacity(
                              opacity: _loading == true ? 1.0 : 0.0,
                              child: const LoadingIndicatorWidget());
                        },
                        childCount:
                            _articles.isEmpty ? 6 : _articles.length + 1,
                      ),
                    ),
                  ),
          ],
        ),
        onRefresh: () async => _onRefresh(),
      ),
    );
  }

  FlexibleSpaceBar _flexibleSpaceBar() {
    return FlexibleSpaceBar(
      centerTitle: false,
      background: Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        child: HeroMode(
          enabled: widget.heroTag != null &&
              widget.category.categoryThumbnail != null,
          child: Hero(
            tag: widget.heroTag ?? '',
            child: CustomCacheImageWithDarkFilterBottom(
                imageUrl: widget.isManual == true
                    ? "https://arynews.tv/wp-content/uploads/2025/02/placeholder_bg.jpg"
                    : widget.category.categoryThumbnail,
                radius: 0.0),
          ),
        ),
      ),
      title: Text(
          widget.isManual == true
              ? widget.sidebar!.title.toString()
              : widget.category.name.toString(),
          style: const TextStyle(color: Colors.white, fontFamily: 'Manrope')),
      titlePadding: const EdgeInsets.only(left: 20, bottom: 15, right: 20),
    );
  }
}
