import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import '../../Helper/constant.dart';
import '../home_page/home_page.dart';
import 'cricket_score.dart';

int strikerIndex = -1;
int non_strikerIndex = -1;
int baller_index = -1;
var selectedStriker;
var selectedNonStriker;
var selectedBaller;

class CricketStrickerAndNonStrickerDetails extends StatefulWidget {
  final String tournamentId;
  final String battingTeamName;
  final String bowlingTeamName;
  final int overs;
  final int wickets;
  final bool first;
  final String tossWonBy;
  final String tossWinnerChoseTo;
  var battingTeamPlayers;
  var bowlingTeamPlayers;
  var MATCH_ID;
  final int score_to_beat;
  CricketStrickerAndNonStrickerDetails({
    Key? key,
    required this.tournamentId,
    required this.battingTeamName,
    required this.bowlingTeamName,
    required this.battingTeamPlayers,
    required this.bowlingTeamPlayers,
    required this.first,
    required this.overs,
    required this.wickets,
    required this.tossWonBy,
    required this.tossWinnerChoseTo,
    required this.MATCH_ID,
    required this.score_to_beat,
  }) : super(key: key);
  @override
  State<CricketStrickerAndNonStrickerDetails> createState() =>
      _CricketStrickerAndNonStrickerDetailsState();
}

class _CricketStrickerAndNonStrickerDetailsState
    extends State<CricketStrickerAndNonStrickerDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> sliced = widget.battingTeamPlayers;
    List<dynamic> sliced2 = widget.bowlingTeamPlayers;

    List<dynamic> bat = widget.battingTeamPlayers;
    List<dynamic> ball = widget.bowlingTeamPlayers;

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    var i = 0;
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
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                    ),
                  ),
                  // Expanded(
                  //   flex: 1,
                  //   child: Container(
                  //     width: deviceWidth * 0.08,
                  //     height: deviceWidth * 0.08,
                  //     decoration: const BoxDecoration(
                  //         image: DecorationImage(
                  //             image: AssetImage("assets/money_bag.png"),
                  //             fit: BoxFit.fitHeight)),
                  //   ),
                  // ),
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
                  // Expanded(
                  //   flex: 1,
                  //   child: Container(
                  //     margin: EdgeInsets.only(left: deviceWidth * 0.03),
                  //     child: const Text("₹15,000"),
                  //   ),
                  // ),
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
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            widget.battingTeamName,
                            style: const TextStyle(
                                color: Color(0xffE74545),
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
                                  // Select Striker
                                  child: DropdownButtonFormField(
                                    hint: const Text("Select Striker"),
                                    items: sliced
                                        .where((element) =>
                                            element != selectedNonStriker)
                                        .toList()
                                        .map((e) => DropdownMenuItem(
                                              child: Text(e["NAME"]),
                                              value: e["index"],
                                            ))
                                        .toList(),
                                    onChanged: (e) {
                                      setState(() {
                                        strikerIndex = e as int;
                                        selectedStriker =
                                            widget.battingTeamPlayers[e as int];
                                        bat.remove(widget
                                            .battingTeamPlayers[e as int]);
                                        if (strikerIndex != -1) {
                                          bat.insert(e as int, selectedStriker);
                                        }
                                      });
                                    },
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
                                  child: DropdownButtonFormField(
                                    hint: const Text("Select Non Striker"),
                                    items: sliced
                                        .where((element) =>
                                            element != selectedStriker)
                                        .toList()
                                        .map((e) => DropdownMenuItem(
                                              child: Text(e["NAME"]),
                                              value: e["index"],
                                            ))
                                        .toList(),
                                    onChanged: (e) {
                                      setState(() {
                                        non_strikerIndex = e as int;
                                        selectedNonStriker =
                                            widget.battingTeamPlayers[e as int];
                                      });
                                    },
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
                        child: Center(
                          child: Text(
                            widget.bowlingTeamName,
                            style: const TextStyle(
                                color: Color(0xffE74545),
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
                                  //rishi
                                  child: DropdownButtonFormField(
                                    hint: const Text("Select Bowler"),
                                    items: sliced2
                                        .map((e) => DropdownMenuItem(
                                              child: Text(e["NAME"]),
                                              value: e["index"],
                                            ))
                                        .toList(),
                                    onChanged: (e) {
                                      setState(() {
                                        baller_index = e as int;
                                        selectedBaller =
                                            widget.bowlingTeamPlayers[e as int];
                                      });
                                    },
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
                          flex: 4,
                          child: Container(
                            height: double.infinity,
                          )),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffD15858),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      deviceWidth * 0.04)),
                            ),
                            onPressed: () async {
                              var requestJson = {
                                "TOURNAMENT_ID": widget.tournamentId,
                                "BATTING": {
                                  "STRIKER_INDEX": strikerIndex,
                                  "NON_STRIKER_INDEX": non_strikerIndex
                                },
                                "BOWLING": {"BALLER_INDEX": baller_index},
                                "MATCH_ID": widget.MATCH_ID
                              };
                              var sendJson = jsonEncode(requestJson);
                              var url =
                                  "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/updatePlayers";
                              var response = await post(Uri.parse(url),
                                  body: sendJson,
                                  headers: {
                                    "Content-Type": "application/json"
                                  });
                              bat = widget.battingTeamPlayers
                                  .where((element) =>
                                      element != selectedStriker &&
                                      element != selectedNonStriker)
                                  .toList();
                              ball = widget.bowlingTeamPlayers
                                  .where((element) => element != selectedBaller)
                                  .toList();
                              print("Changing Innings, so widget.first in stnstpage is ${widget.first}");
                              print({
                                "first": widget.first,
                                "wickets": widget.wickets,
                                "overs": widget.overs, //no
                                "striker": selectedStriker,
                                "non_striker": selectedNonStriker,
                                "baller": selectedBaller,
                                "battingTeamName":
                                widget.battingTeamName,
                                "bowlingTeamName":
                                widget.bowlingTeamName,
                                "tournamentId": widget.tournamentId,
                                "tossWonBy": widget.tossWonBy,
                                "tossWinnerChoseTo":
                                widget.tossWinnerChoseTo,
                                "MATCH_ID": widget.MATCH_ID,
                                "score": 0,
                                "overs_done": 0.0,
                                "over_string": "",
                                "wickets_taken": 0,
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CricketScore(
                                          battingTeam: bat,
                                          ballingTeam: ball,
                                          allBattingPlayers:
                                              widget.battingTeamPlayers,
                                          allBallingPlayers:
                                              widget.bowlingTeamPlayers,
                                          first: widget.first,
                                          wickets: widget.wickets,
                                          overs: widget.overs, //no
                                          striker: selectedStriker,
                                          non_striker: selectedNonStriker,
                                          baller: selectedBaller,
                                          battingTeamName:
                                              widget.battingTeamName,
                                          bowlingTeamName:
                                              widget.bowlingTeamName,
                                          tournamentId: widget.tournamentId,
                                          tossWonBy: widget.tossWonBy,
                                          tossWinnerChoseTo:
                                              widget.tossWinnerChoseTo,
                                          MATCH_ID: widget.MATCH_ID,
                                          score: 0,
                                          overs_done: 0.0,
                                          over_string: "",
                                        wickets_taken: 0,
                                      score_to_beat : widget.score_to_beat,
                                        )),
                              );
                            },
                            child: const Text("Start Scoring"),
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

class match_Details {
  late String matchid;
  late List<String> team_1;
  late List<String> team_2;
  late int team_1_score;
  late int team_2_score;
  late int team_1_wickets;
  late int team_2_wickets;
  late int team_1_target;
  late int team_2_target;
  late String winning_team;
  late int no_of_overs;
  late String ball_type;
  late String city;
  late int playing_team_size;
  late String toss_won_by;
  late String elected_to;
  match_Details(
      {required this.matchid,
      required this.team_1,
      required this.team_2,
      required this.team_1_score,
      required this.team_2_score,
      required this.team_1_wickets,
      required this.team_2_wickets,
      required this.team_1_target,
      required this.team_2_target,
      required this.winning_team,
      required this.no_of_overs,
      required this.ball_type,
      required this.city,
      required this.playing_team_size,
      required this.toss_won_by,
      required this.elected_to});
  Map<String, dynamic> toMap() {
    return {
      "matchid": matchid,
      "team_1": team_1,
      "team_2": team_2,
      "team_1_score": team_1_score,
      "team_2_score": team_2_score,
      "team_1_wickets": team_1_wickets,
      "team_2_wickets": team_2_wickets,
      "team_1_target": team_1_target,
      "team_2_target": team_2_target,
      "winning_team": winning_team,
      "no_of_overs": no_of_overs,
      "ball_type": ball_type,
      "city": city,
      "playing_team_size": playing_team_size,
      "toss_won_by": toss_won_by,
      "elected_to": elected_to
    };
  }
}
