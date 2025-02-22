import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/models/tools_widget.dart';
import '../models/article.dart';

class WebViewPage extends StatefulWidget {
  final ToolsWidget toolsWidget;
  const WebViewPage({super.key, required this.toolsWidget});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final List<Article> _articles = [];
  ScrollController? _controller;
  int page = 1;
  bool? _loading;
  bool? _hasData;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final int _postAmount = 10;
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

    controllerWV
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.toolsWidget.tag.toString()));
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
          '${widget.toolsWidget.title}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: WebViewWidget(controller: controllerWV),
    );
  }
}
