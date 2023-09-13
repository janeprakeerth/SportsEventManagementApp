import 'package:ardent_sports/features/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart';
import '../home_page/home_page.dart';

class WebViewTest extends StatefulWidget {
  final String Tourney_id;
  final String? userId;
  final String SpotNo;
  final String Sport;
  const WebViewTest(
      {Key? key,
      required this.Tourney_id,
      required this.userId,
      required this.SpotNo,
      required this.Sport})
      : super(key: key);

  @override
  State<WebViewTest> createState() => _WebViewTestState();
}

class _WebViewTestState extends State<WebViewTest> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    print('Tourney_id: ${widget.Tourney_id}');
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);

        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Fixtures'),
            actions: [
              IconButton(
                  onPressed: () async {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (a, b, c) => const HomePage()));
                  },
                  icon: const Icon(Icons.home)),
            ],
          ),
          body:
          WebView(
            initialUrl: (widget.Sport == 'Cricket')
                ? 'http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/cricketFixtures?TOURNAMENT_ID=${widget.Tourney_id}'
                : 'http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/getBookingFixtures?TOURNAMENT_ID=${widget.Tourney_id}&USERID=${widget.userId}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) => _controller = controller,
          )),
    );
  }
}
