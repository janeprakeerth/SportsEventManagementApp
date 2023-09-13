import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../Helper/constant.dart';
import '../home_page/home_page.dart';
import 'cricket_score.dart';

class MatchResult extends StatefulWidget {
  final String TOURNAMENT_ID;
  final int MATCH_ID;
  final dynamic allData;
  MatchResult({
    required this.TOURNAMENT_ID,
    required this.MATCH_ID,
    required this.allData,
    Key? key,
  }) : super(key: key);
  @override
  State<MatchResult> createState() => _MatchResult();
}

class _MatchResult extends State<MatchResult> {
  var TeamA;
  var TeamB;
  var TeamAOver;
  var TeamBOver;
  var TeamAMatchScore;
  var TeamBMatchScore;
  var TeamAWickets;
  var TeamBWickets;
  final String tournamentId = "";
  String Teamwinner = "";

  void ChangeAll() async {

    print(widget.allData);
    print(widget.allData["scoreCard"][0]);
    print(widget.allData["scoreCard"][1]);
    print(widget.allData["WinnerTeam"]);
    var e = widget.allData["scoreCard"][0];
    var f = widget.allData["scoreCard"][1];
    setState(() {
      Teamwinner = widget.allData["WinnerTeam"];
      TeamA = e["TeamName"];
      TeamB = f["TeamName"];
      TeamAOver = e["TeamOvers"];
      TeamBOver = f["TeamOvers"];
      TeamAMatchScore = e["TeamTotal"];
      TeamBMatchScore = f["TeamTotal"];
      TeamAWickets = e["TeamWickets"];
      TeamBWickets = f["TeamWickets"];
    });
  }

  @override
  void initState() {
    super.initState();
    ChangeAll();
  }

  @override
  Widget build(BuildContext context) {
    // declaring the list of players
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Homepage.png"), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: deviceWidth * 0.26,
                      height: deviceWidth * 0.08,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/Ardent_Sport_Text.png"),
                              fit: BoxFit.fitWidth)),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.white,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.height / 3,
                margin: EdgeInsets.all(deviceWidth * 0.02),
                child: Center(
                    child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.03)),
                  color: Colors.white.withOpacity(0.2),
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Center(
                          child: Text("Match Result"),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: deviceWidth * 0.15,
                                  margin: EdgeInsets.fromLTRB(
                                      deviceWidth * 0.02,
                                      0,
                                      deviceWidth * 0.02,
                                      0),
                                  // Select Striker
                                  child: Container(
                                    child: Row(children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            TeamA,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            "$TeamAMatchScore/$TeamAWickets ($TeamAOver)",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.02),
                                      color: Colors.black.withOpacity(0.4))),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: deviceWidth * 0.15,
                                  margin: EdgeInsets.fromLTRB(
                                      deviceWidth * 0.02,
                                      0,
                                      deviceWidth * 0.02,
                                      0),
                                  child: Container(
                                    child: Row(children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            TeamB,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            "$TeamBMatchScore/$TeamBWickets ($TeamBOver)",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.02),
                                      color: Colors.black.withOpacity(0.4))),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                  height: deviceWidth * 0.15,
                                  margin: EdgeInsets.fromLTRB(
                                      deviceWidth * 0.02,
                                      0,
                                      deviceWidth * 0.02,
                                      0),
                                  child: Row(children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text("$Teamwinner won"),
                                      ),
                                    ),
                                  ]),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.02),
                                      color: Colors.black.withOpacity(0.4))),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffD15858),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      deviceWidth * 0.04)),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                            },
                            child: const Text("Confirm"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceWidth * 0.02,
                      )
                    ],
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
