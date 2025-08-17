import 'package:flutter/material.dart';
import 'package:flutter_webview/production_web_view.dart';
import 'web_view_screen.dart';
import 'web_view_simple_screen.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Dependency Injection with get_it',
            style: TextStyle(fontSize: 14),
          ),
          backgroundColor: const Color(0xff1D1E22)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            OutlinedButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WebViewSimpleScreen()),
                );
              },
              child: const Text('WebView Simple'),
            ),

            OutlinedButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WebViewScreen()),
                );
              },
              child: const Text('WebView JavaScript Channel'),
            ),

            OutlinedButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductionWebView(initialUrl: 'https://applicazioni-web.net/webview/')),
                );
              },
              child: const Text('WebView URL Schemes'),
            ),
          ],
        ),
      ),
    );
  }
}