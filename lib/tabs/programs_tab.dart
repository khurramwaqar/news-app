import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/cards/card3.dart';
import 'package:wordpress_app/models/news_programs.dart';
import 'package:wordpress_app/pages/programs_playlist.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/widgets/inline_ads.dart';
import 'package:wordpress_app/widgets/loading_indicator_widget.dart';
import 'package:wordpress_app/utils/next_screen.dart';

import 'package:http/http.dart' as http;

class ProgramsTab extends StatefulWidget {
  const ProgramsTab({super.key});

  @override
  State<ProgramsTab> createState() => _ProgramsTabState();
}

class _ProgramsTabState extends State<ProgramsTab>
    with AutomaticKeepAliveClientMixin {
  late Future<NewsPrograms> futureNewsPrograms;

  final List<Article> _articles = [];
  final List<Series> _series = [];
  ScrollController? _controller;
  int _page = 1;
  bool? _loading;
  bool? _hasData;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final int _postAmount = 10;

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller!.addListener(_scrollListener);

    super.initState();
    futureNewsPrograms = fetchNewsPrograms();
    _hasData = true;
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Future<NewsPrograms> fetchNewsPrograms() async {
    final response = await http.get(
      Uri.parse(
          'https://node.aryzap.com/api/series/byCatID/NEWS%20TALK%20SHOWS/PK'),
    );

    if (response.statusCode == 200) {
      return newsProgramsFromJson(response.body);
    } else {
      throw Exception('Failed to load news programs');
    }
  }

  _scrollListener() async {
    var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange;
    if (isEnd && _series.isNotEmpty) {
      setState(() {
        _page += 1;
        _loading = true;
      });
      await fetchNewsPrograms().then((value) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  Future _onRefresh() async {
    setState(() {
      _loading = null;
      _series.clear();
      _hasData = true;
      _page = 1;
    });
    await fetchNewsPrograms();
  }

  @override
  Widget build(BuildContext context) {
    final configs = context.read<ConfigBloc>().configs!;
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('news-shows').tr(),
        actions: [
          IconButton(
            icon: const Icon(
              Feather.rotate_cw,
              size: 22,
            ),
            onPressed: () async => await _onRefresh(),
          )
        ],
      ),
      body: FutureBuilder<NewsPrograms>(
        future: futureNewsPrograms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data?.series?.isEmpty == true) {
            return const Center(child: Text('No news programs available.'));
          } else {
            final seriesList = snapshot.data?.series ?? [];

            return ListView.builder(
              padding: const EdgeInsets.only(top: 10.0, left: 5.0),
              itemCount: seriesList.length,
              itemBuilder: (context, index) {
                final series = seriesList[index];
                return InkWell(
                  onTap: () => {
                    nextScreenPopupSinglePlaylist(
                        context,
                        ProgramsPlaylist(
                          episode: series.id.toString(),
                          episodeTitle: series.title.toString(),
                        ))
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, right: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            "https://node.aryzap.com/public/${series.imagePoster!}",
                            width: 100,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Series Title
                          SizedBox(
                            width: MediaQuery.of(context).size.width -
                                120, // Adjust based on image width + padding
                            child: Text(
                              series.title.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          // Series Description
                          SizedBox(
                            width: MediaQuery.of(context).size.width -
                                120, // Adjust based on image width + padding
                            child: Text(
                              series.description.toString(),
                              maxLines: null,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
