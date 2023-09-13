import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../home_page/home_page.dart';

class WebViewSpots extends StatefulWidget {
  final String? spots;

  const WebViewSpots({Key? key, required this.spots}) : super(key: key);

  @override
  State<WebViewSpots> createState() => _WebViewSpotsState();
}

class _WebViewSpotsState extends State<WebViewSpots> {
  late WebViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixtures'),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (a, b, c) => const HomePage(),
                  ),
                );
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
            'http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/?no_of_spots=${widget.spots}',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
