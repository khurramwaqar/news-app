import 'dart:ffi';

import 'package:flare_flutter/base/math/aabb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/cards/sliver_card1.dart';
import 'package:wordpress_app/models/post_tag.dart';
import 'package:wordpress_app/models/programs_playlist.dart';
import 'package:wordpress_app/models/tools_widget.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:wordpress_app/utils/empty_image.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/widgets/inline_ads.dart';
import 'package:wordpress_app/widgets/loading_indicator_widget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/article.dart';
import 'package:easy_localization/easy_localization.dart';

class SingleProgram extends StatefulWidget {
  final Episode episode;
  const SingleProgram({super.key, required this.episode});

  @override
  State<SingleProgram> createState() => _SingleProgramState();
}

class _SingleProgramState extends State<SingleProgram> {
  final List<Article> _articles = [];
  ScrollController? _controller;
  int page = 1;
  bool? _loading;
  bool? _hasData;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final int _postAmount = 10;

  final _controlleryt = YoutubePlayerController.fromVideoId(
    videoId: 'HKvtByXSNG4',
    params: const YoutubePlayerParams(
      mute: false,
      showControls: true,
      showFullscreenButton: true,
    ),
  );

  @override
  void initState() {
    // _controller =
    //     ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    // _controller!.addListener(_scrollListener);
    // _hasData = true;
    //_fetchData();
    super.initState();
  }

  // Future _fetchData() async {
  //   await WordPressService()
  //       .fetchPostsByTag(page, widget.tag.id, _postAmount)
  //       .then((value) {
  //     _articles.addAll(value);
  //     _loading = false;
  //     if (_articles.isEmpty) {
  //       _hasData = false;
  //     }
  //     setState(() {});
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    //_controller!.dispose();
  }

  // _scrollListener() async {
  //   var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
  //       !_controller!.position.outOfRange;
  //   if (isEnd && _articles.isNotEmpty) {
  //     setState(() {
  //       page += 1;
  //       _loading = true;
  //     });
  //     await _fetchData().then((value) {
  //       setState(() {
  //         _loading = false;
  //       });
  //     });
  //   }
  // }

  Future _onRefresh() async {
    setState(() {
      _loading = null;
      _hasData = true;
      //_articles.clear();
      page = 1;
    });
    //_fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final configs = context.read<ConfigBloc>().configs!;
    final WebViewController controllerWV = WebViewController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          '${widget.episode.title}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(children: [
                Card(
                  elevation: 10,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 401.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          // child: YoutubePlayerScaffold(
                          //   controller: _controlleryt,
                          //   aspectRatio: 16 / 9,
                          //   builder: (context, player) {
                          //     return Column(
                          //       children: [
                          //         player,
                          //         // Text('Youtube Player'),
                          //       ],
                          //     );
                          //   },
                          // ),
                          child: YoutubePlayer(
                            controller: YoutubePlayerController.fromVideoId(
                              videoId: widget.episode.videoYtId.toString(),
                              params: const YoutubePlayerParams(
                                mute: false,
                                showControls: true,
                                showFullscreenButton: true,
                              ),
                            ),
                            aspectRatio: 16 / 9,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.episode.title.toString(),
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 10,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Expanded(
                      child: Text(
                        widget.episode.description.toString(),
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
