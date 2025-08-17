import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewSimpleScreen extends StatefulWidget {
  const WebViewSimpleScreen({super.key});

  @override
  State<WebViewSimpleScreen> createState() => _WebViewSimpleScreenState();
}

class _WebViewSimpleScreenState extends State<WebViewSimpleScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://flutter.dev'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter WebView')),
      body: WebViewWidget(controller: _controller),
    );
  }
}