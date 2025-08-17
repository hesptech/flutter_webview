import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class ProductionWebView extends StatefulWidget {
  final String initialUrl;
  
  const ProductionWebView({super.key, required this.initialUrl});
  
  @override
  ProductionWebViewState createState() => ProductionWebViewState();
}

class ProductionWebViewState extends State<ProductionWebView> {
  late WebViewController _controller;
  bool isLoading = true;
  bool showAppBar = false;
  String pageTitle = 'Production Web View';
  
  @override
  void initState() {
    super.initState();
    _initializeController();
  }
  
  void _initializeController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('YourApp/1.0')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => _onPageStarted(url),
          onPageFinished: (url) => _onPageFinished(url),
          onUrlChange: (change) => _onUrlChange(change.url),
          //onNavigationRequest: (request) => _onNavigationRequest(request),
          //onWebResourceError: (error) => _onWebResourceError(error),
        ),
      )
      ..addJavaScriptChannel(
        'AppInterface',
        onMessageReceived: _handleJavaScriptMessage,
      );
      
    _controller.loadRequest(Uri.parse(widget.initialUrl));
  }
  
  void _onPageStarted(String url) {
    setState(() {
      isLoading = true;
    });
  }
  
  void _onPageFinished(String url) async {
    setState(() {
      isLoading = false;
    });
    
    // Get page title
    final title = await _controller.getTitle();
    setState(() {
      pageTitle = title ?? 'WebView';
    });
    
    // Inject custom JavaScript
    await _controller.runJavaScript('''
      // Add app interface
      window.AppInterface.postMessage(JSON.stringify({
        type: 'pageReady',
        url: window.location.href,
        title: document.title
      }));
    ''');
  }
  
  void _onUrlChange(String? url) {
    if (url == null) return;
    
    // Show/hide app bar based on URL
    final shouldShow = url.contains('external') || url.contains('blog');
    if (showAppBar != shouldShow) {
      setState(() {
        showAppBar = shouldShow;
      });
    }
  }
  
  /* NavigationDecision _onNavigationRequest(NavigationRequest request) {
    // Handle special URLs
    if (request.url.startsWith('mailto:')) {
      _launchEmail(request.url);
      return NavigationDecision.prevent;
    }
    
    if (request.url.startsWith('tel:')) {
      _launchPhone(request.url);
      return NavigationDecision.prevent;
    }
    
    return NavigationDecision.navigate;
  }
  
  void _onWebResourceError(WebResourceError error) {
    _showErrorDialog('Failed to load page: ${error.description}');
  } */
  
  void _handleJavaScriptMessage(JavaScriptMessage message) {
    try {
      final data = json.decode(message.message);
      
      switch (data['type']) {
        case 'pageReady':
          print('Page ready: ${data['title']}');
          break;
        case 'goBack':
          _smartGoBack();
          break;
        case 'openExternal':
          //_launchExternal(data['url']);
          break;
      }
    } catch (e) {
      print('Error handling message: $e');
    }
  }
  
  Future<void> _smartGoBack() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
    } else {
      Navigator.of(context).pop();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar(
        title: Text(pageTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ) : null,
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (!didPop) {
            await _smartGoBack();
          }
        },
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}