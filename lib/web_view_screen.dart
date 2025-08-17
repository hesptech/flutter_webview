import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;
  bool isLoading = true;
  String currentUrl = '';

  @override
  void initState() {
    //WidgetsFlutterBinding.ensureInitialized();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://applicazioni-web.net/webview/'))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => _onPageStarted(url),
          onPageFinished: (url) => _onPageFinished(url),
        ),
      );
    super.initState();
  }

  void _onPageStarted(String url) {
    setState(() {
      isLoading = true;
      currentUrl = url;
    });
  }

  void _onPageFinished(String url) {
    setState(() {
      isLoading = false;
      currentUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView Mastery'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}