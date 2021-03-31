import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticlePage extends StatefulWidget {

  final String postUrl;
  ArticlePage({@required this.postUrl});

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {

  final Completer<WebViewController> _completer = Completer<WebViewController>();
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    print('Web View URL : '+widget.postUrl);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("News"),
            Text(" Update",style: TextStyle(
              color: Colors.black,
            ),)
          ],
        ),
        actions: <Widget>[
          Opacity(opacity: 0,child: Container(padding: EdgeInsets.symmetric(horizontal: 16),child: Icon(Icons.save))),
        ],
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WebView(
            key: _key,
            initialUrl: widget.postUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _completer.complete(webViewController);
            },
          )
      ),
    );
  }
}