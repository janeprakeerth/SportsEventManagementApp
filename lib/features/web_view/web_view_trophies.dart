import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../home_page/home_page.dart';



class WebViewTrophie extends StatefulWidget {
  final String? userId;

  const WebViewTrophie({Key? key, required this.userId}) : super(key: key);

  @override
  State<WebViewTrophie> createState() => _WebViewTrophieState();
}

class _WebViewTrophieState extends State<WebViewTrophie> {
  late WebViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trophies'),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.pushReplacement(context,
                    PageRouteBuilder(pageBuilder: (a, b, c) => const HomePage()));
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: WebView(
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(
              name: 'Print',
              onMessageReceived: (JavascriptMessage message) {
                print(message.message);
              }),
        },
        initialUrl:
            'http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/trophy?USERID=${widget.userId}',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
