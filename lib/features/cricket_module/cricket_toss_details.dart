import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../Helper/constant.dart';
import '../home_page/home_page.dart';
import 'cricket_stricker_and_non_stricker_details.dart';

class CricketTossDetails extends StatefulWidget {
  final String firstTeamName;
  final String secondTeamName;
  final String tournamentId;
  final int MATCH_ID;
  const CricketTossDetails({
    Key? key,
    required this.firstTeamName,
    required this.secondTeamName,
    required this.tournamentId,
    required this.MATCH_ID
  }) : super(key: key);

  @override
  State<CricketTossDetails> createState() => _CricketTossDetailsState();
}

class _CricketTossDetailsState extends State<CricketTossDetails> {
  @override
  void initState() {
    super.initState();
    print("😌😌" + widget.firstTeamName);
    print("😌😌" + widget.secondTeamName);
  }

  var toss_won_by = "";
  var chose_to = "";
  var battingTeamName = "";
  var bowlingTeamName = "";
  var firstTeamPlayers = <String>[];
  var secondTeamPlayers = <String>[];
  var battingTeamPlayers = [];
  var bowlingTeamPlayers = [];
  var batColor = Colors.black;
  var ballColor = Colors.black;
  var firstTeamColor = Colors.black;
  var secondTeamColor = Colors.black;
  @override
  Widget build(BuildContext context) {
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
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (a, b, c) => const HomePage()));
                      },
                      child: Container(
                        width: deviceWidth * 0.18,
                        height: deviceWidth * 0.1,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/AARDENT_LOGO.png"),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
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
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: deviceWidth * 0.08,
                      height: deviceWidth * 0.08,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/Profile_Image.png"),
                              fit: BoxFit.fitHeight)),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: deviceWidth * 0.03),
                      child: const Text("Shubham"),
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
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.height / 3,
                margin: EdgeInsets.all(deviceWidth * 0.02),
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
                          child: Text(
                            "Toss Won By",
                            style: TextStyle(
                                color: Color(0xffE74545),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
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
                                  child: Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: firstTeamColor),
                                      onPressed: () {
                                        print("😌😌 chose_to::::" + chose_to);
                                        toss_won_by = widget.firstTeamName;
                                        if(chose_to=="BAT"){
                                          battingTeamName = widget.firstTeamName;
                                          bowlingTeamName = widget.secondTeamName;
                                          battingTeamPlayers = firstTeamPlayers;
                                          bowlingTeamPlayers = secondTeamPlayers;
                                          print("😌😌 battingTeamPlayers::::" + battingTeamPlayers.toString());
                                          print("😌😌 bowlingTeamPlayers::::" + bowlingTeamPlayers.toString());
                                        }
                                        else{
                                          battingTeamName = widget.secondTeamName;
                                          bowlingTeamName = widget.firstTeamName;
                                          battingTeamPlayers = secondTeamPlayers;
                                          bowlingTeamPlayers = firstTeamPlayers;
                                        }
                                        setState(() {
                                          firstTeamColor = Colors.red;
                                          secondTeamColor = Colors.black;
                                        });
                                      },
                                      child: Text(
                                        widget.firstTeamName,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.02),
                                      color: firstTeamColor)),
                            ),
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
                                  child: Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: secondTeamColor),
                                      onPressed: () {
                                        toss_won_by = widget.secondTeamName;
                                        print("😌😌 toss::::" + toss_won_by);
                                        print("😌😌 chose_to::::" + chose_to);
                                        if(chose_to=="BAT"){
                                          battingTeamName = widget.secondTeamName;
                                          bowlingTeamName = widget.firstTeamName;
                                          battingTeamPlayers = secondTeamPlayers;
                                          bowlingTeamPlayers = firstTeamPlayers;
                                        }
                                        else{
                                          battingTeamName = widget.firstTeamName;
                                          bowlingTeamName = widget.secondTeamName;
                                          battingTeamPlayers = firstTeamPlayers;
                                          bowlingTeamPlayers = secondTeamPlayers;
                                        }
                                        setState(() {
                                          secondTeamColor = Colors.red;
                                          firstTeamColor = Colors.black;
                                        });
                                      },
                                      child: Text(
                                        widget.secondTeamName,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.02),
                                      color: secondTeamColor)),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "elected to",
                            style: TextStyle(
                                color: Color(0xffE74545),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
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
                                  child: Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: batColor),
                                      onPressed: () {
                                        chose_to = "BAT";
                                        // change color of the button
                                        setState(() {
                                          batColor = Colors.red;
                                          ballColor = Colors.black;
                                        });
                                        if (toss_won_by == widget.firstTeamName) {
                                          battingTeamName =
                                              widget.firstTeamName;
                                          bowlingTeamName =
                                              widget.secondTeamName;
                                        } else if (toss_won_by ==
                                            widget.secondTeamName) {
                                          battingTeamName =
                                              widget.secondTeamName;
                                          bowlingTeamName =
                                              widget.firstTeamName;
                                        }
                                        else{
                                          print("Toss winner not selected yet");
                                        }
                                      },
                                      child: const Text(
                                        "BAT",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.02),
                                      color: batColor)),
                            ),
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
                                  child: Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: ballColor),
                                      onPressed: () {
                                        chose_to = "BALL";
                                        setState(() {
                                          batColor = Colors.black;
                                          ballColor = Colors.red;
                                        });
                                        if (toss_won_by == widget.firstTeamName) {
                                          battingTeamName =
                                              widget.secondTeamName;
                                          bowlingTeamName =
                                              widget.firstTeamName;
                                        } else if (toss_won_by ==
                                            widget.secondTeamName) {
                                          battingTeamName =
                                              widget.firstTeamName;
                                          bowlingTeamName =
                                              widget.secondTeamName;
                                        }
                                      },
                                      child: const Text(
                                        "BALL",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.02),
                                      color: ballColor)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Container(
                            height: double.infinity,
                          )),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: deviceWidth * 0.15,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffD15858),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      deviceWidth * 0.04)),
                            ),
                            onPressed: () async {
                              print(
                                  "team :$toss_won_by won the toss and chose to $chose_to. The tournament id is ${widget.tournamentId}");
                              print(
                                  "Batting team is $battingTeamName and bowling team is $bowlingTeamName");
                              // api call
                              var tossDetailsObj = {
                                "TOURNAMENT_ID": widget.tournamentId,
                                "TEAM_FORMAT": [
                                  widget.firstTeamName,
                                  widget.secondTeamName
                                ],
                                "CHOSEN_TO": chose_to,
                                "TEAM_NAME": toss_won_by,
                                "MATCH_ID" : widget.MATCH_ID,
                              };
                              var sendTossDetailsObj =
                                  jsonEncode(tossDetailsObj);
                              print(
                                  "👌 Object is : $tossDetailsObj and the json sent is $sendTossDetailsObj");
                              var url =
                                  "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/updateToss";
                              var response = await post(Uri.parse(url),
                                  body: sendTossDetailsObj,
                                  headers: {
                                    "Content-Type": "application/json"
                                  });
                              var allPlayersData = jsonDecode(response.body);
                              print("😒😒😒😒 Response : $allPlayersData");
                              // set the batting team and bowling team players

                              var teamOne = allPlayersData['one'];
                              var teamTwo = allPlayersData['two'];
                              print("PARTH EDIT HERE  ");
                              print(teamOne);
                              print(teamTwo);

                              var batTeam = [];
                              var ballTeam = [];
                              for (int i = 0; i < teamOne.length; i++) {
                                batTeam.add({
                                  "USERID": teamOne[i]["USERID"],
                                  "NAME": teamOne[i]["NAME"],
                                  "index": i,
                                  "SCORE": 0,
                                  "BALLS" : 0,
                                });
                              }
                              for (int i = 0; i < teamTwo.length; i++) {
                                ballTeam.add({
                                  "USERID": teamTwo[i]["USERID"],
                                  "NAME": teamTwo[i]["NAME"],
                                  "index": i,
                                  "BALLS" : 0,
                                  "SCORE" : 0
                                });
                              }
                              print("New Edit Here");
                              print(battingTeamName);
                              print(bowlingTeamName);
                              print(batTeam);
                              print(ballTeam);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CricketStrickerAndNonStrickerDetails(
                                          battingTeamName: battingTeamName,
                                          bowlingTeamName: bowlingTeamName,
                                          tournamentId: widget.tournamentId,
                                          battingTeamPlayers: batTeam,
                                          bowlingTeamPlayers: ballTeam,
                                          overs: allPlayersData["overs"],
                                          wickets: allPlayersData["wickets"],
                                          first: allPlayersData["first"],
                                          tossWonBy: toss_won_by,
                                          tossWinnerChoseTo: chose_to,
                                          MATCH_ID : widget.MATCH_ID,
                                          score_to_beat: 10000,
                                        )),
                              );
                            },
                            child: const Text("Next"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
