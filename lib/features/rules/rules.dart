// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../home_page/home_page.dart';

class Rules extends StatefulWidget {
  final String tourneyId;
  const Rules({Key? key, required this.tourneyId}) : super(key: key);

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  Map? rules;
  getRules() async {
    EasyLoading.show(status: "Loading...", maskType: EasyLoadingMaskType.black);
    final url = Uri.parse(
        'http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/getrules?TOURNAMENT_ID=${widget.tourneyId}');

    print(widget.tourneyId);

    http.Response response;
    response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        setState(() {
          rules = json.decode(response.body);
        });
      } else if (response.statusCode == 400) {
        EasyLoading.dismiss();
        EasyLoading.showError("Error");
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Error Occured, Please try again");
    }
  }

  @override
  void initState() {
    getRules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Homepage.png"), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (a, b, c) => const HomePage()));
                      },
                      child: Container(
                        width: deviceWidth * 0.2,
                        height: deviceHeight * 0.07,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/AARDENT_LOGO.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: deviceWidth * 0.2,
                      height: deviceHeight * 0.08,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/Ardent_Sport_Text.png"),
                              fit: BoxFit.fitWidth)),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white,
                ),
                Text("Rules of the Tournament are",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: deviceHeight * 0.05,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    rules == null ? "Loading.." : rules?['Message'],
                    softWrap: true,
                    style: TextStyle(
                        height: 1.55,
                        color: Colors.white,
                        fontSize: 16,
                        wordSpacing: 0),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
