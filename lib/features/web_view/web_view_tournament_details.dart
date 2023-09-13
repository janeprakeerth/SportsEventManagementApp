// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../home_page/home_page.dart';

class WebViewTournamentDetails extends StatefulWidget {
  final String? Tournament_Id;

  const WebViewTournamentDetails({Key? key, required this.Tournament_Id})
      : super(key: key);

  @override
  State<WebViewTournamentDetails> createState() =>
      _WebViewTournamentDetailsState();
}

class _WebViewTournamentDetailsState extends State<WebViewTournamentDetails> {
  late WebViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Details'),
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
        // ignore: prefer_collection_literals
        javascriptChannels: <JavascriptChannel>[
          JavascriptChannel(
              name: 'Print',
              onMessageReceived: (JavascriptMessage message) {
                print(message.message);
              }),
        ].toSet(),
        initialUrl:
            'http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/hosted?TOURNAMENT_ID=${widget.Tournament_Id}',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
