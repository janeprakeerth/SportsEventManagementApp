import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import '../../Helper/constant.dart';
import '../home_page/home_page.dart';
import 'cricket_toss_details.dart';
import 'cricket_score.dart';

class CricketTeamDetasilsInput extends StatefulWidget {
  final String tournamentId;
  final dynamic allMatches;
  const CricketTeamDetasilsInput({
    Key? key,
    required this.tournamentId,
    required this.allMatches,
  }) : super(key: key);

  @override
  State<CricketTeamDetasilsInput> createState() =>
      _CricketTeamDetasilsInputState();
}

class _CricketTeamDetasilsInputState extends State<CricketTeamDetasilsInput> {
  @override
  void initState() {
    super.initState();
  }

  List<String> teamA_Players = [];
  List<String> teamB_Players = [];
  List<Container> buildPlayers(int count, String team_nam) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    List<Container> totalPlayers = [];
    var team_name = Container(
      margin: EdgeInsets.fromLTRB(0, deviceWidth * 0.04, 0, 0),
      child: Center(
        child: Text(
          "$team_nam Add Players",
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
    totalPlayers.add(team_name);
    for (int i = 1; i <= count; i++) {
      var newPlayer = Container(
        width: MediaQuery.of(context).size.width,
        height: deviceWidth * 0.15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(deviceWidth * 0.02),
            color: Colors.black.withOpacity(0.4)),
        margin: EdgeInsets.fromLTRB(deviceWidth * 0.02, deviceWidth * 0.02,
            deviceWidth * 0.02, deviceWidth * 0.02),
        child: TextField(
          onChanged: (text) {
            if (team_name == "Team A") {
              teamA_Players.add(text);
            } else {
              teamB_Players.add(text);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(deviceWidth * 0.02)),
            hintText: 'Player $i',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(deviceWidth * 0.02),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.001)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(deviceWidth * 0.02),
              borderSide: BorderSide(
                color: Colors.black.withOpacity(0.001),
              ),
            ),
          ),
        ),
      );

      totalPlayers.add(newPlayer);
    }
    var submit = Container(
      width: MediaQuery.of(context).size.width,
      height: deviceWidth * 0.1,
      margin: EdgeInsets.fromLTRB(deviceHeight * 0.02, deviceHeight * 0.02,
          deviceWidth * 0.02, deviceWidth * 0.02),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffD15858),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(deviceWidth * 0.02)),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(teamA_Players[1]),
            ),
          );
          Navigator.pop(context, false);
        },
        child: const Text("Submit"),
      ),
    );
    totalPlayers.add(submit);

    return totalPlayers;
  }

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
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.allMatches
                      .map<Widget>(
                        (match) => Column(
                          children: [
                            SizedBox(
                              height: deviceWidth * 0.05,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(deviceWidth * 0.02),
                                  color: Colors.black.withOpacity(0.4)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(match["TEAM_NAMES"][0],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceWidth * 0.05)),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text("Vs",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(deviceWidth * 0.02),
                                  color: Colors.black.withOpacity(0.4)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(match["TEAM_NAMES"][1],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceWidth * 0.05)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: deviceWidth * 0.1,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: deviceWidth * 0.10,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffD15858),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () async {
                                  print("On pressed Clicked");
                                  var url =
                                      "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/hasScoringStarted";
                                  var sendData = jsonEncode({
                                    "TOURNAMENT_ID": widget.tournamentId,
                                    "MATCH_ID": int.parse(match["MATCH_ID"])
                                  });
                                  var response = await post(Uri.parse(url),
                                      body: sendData,
                                      headers: {
                                        "Content-Type": "application/json"
                                      });
                                  print("👍🏻👍🏻👍🏻" + response.body);
                                  if (response.body == "true") {
                                    var url2 =
                                        "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/resumeScoring";
                                    var sendDataForResuming = jsonEncode({
                                      "TOURNAMENT_ID": widget.tournamentId,
                                      "MATCH_ID": int.parse(match["MATCH_ID"])
                                    });
                                    var response = await post(Uri.parse(url2),
                                        body: sendDataForResuming,
                                        headers: {
                                          "Content-Type": "application/json"
                                        });
                                    print("😂😂😂" + response.body);
                                    var data = jsonDecode(response.body);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CricketScore(
                                                battingTeam: data["BATTING"]
                                                    ["LEFT"],
                                                ballingTeam: data["BALLING"]
                                                    ["PLAYERS"],
                                                allBattingPlayers:
                                                    data["BATTING"]["PLAYERS"],
                                                allBallingPlayers:
                                                    data["BALLING"]["PLAYERS"],
                                                first: data["first"],
                                                wickets: data["MATCH"]
                                                    ["WICKETS"], //no
                                                overs: data["MATCH"]
                                                    ["TOTAL_OVERS"], //no
                                                striker: data["BATTING"]
                                                    ["STRIKER"],
                                                non_striker: data["BATTING"]
                                                    ["NON_STRIKER"],
                                                baller: data["BALLING"]
                                                    ["BALLER"],
                                                battingTeamName: data["BATTING"]
                                                    ["TEAM_NAME"],
                                                bowlingTeamName: data["BALLING"]
                                                    ["TEAM_NAME"],
                                                tournamentId:
                                                    widget.tournamentId,
                                                tossWonBy: data["MATCH"]
                                                    ["TOSS_WINNER"],
                                                tossWinnerChoseTo: data["MATCH"]
                                                    ["TOSS"],
                                                MATCH_ID: int.parse(
                                                    match["MATCH_ID"]),
                                                score: data["MATCH"]["SCORE"],
                                                overs_done: data["MATCH"]
                                                        ["OVERS"]
                                                    .toDouble(),
                                                over_string: data["MATCH"]
                                                    ["CURR_OVERS"],
                                                wickets_taken: data["MATCH"]
                                                    ["WICKETS_TAKEN"],
                                            score_to_beat: data["score_to_beat"],
                                              )),
                                    );
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CricketTossDetails(
                                                    firstTeamName:
                                                        match["TEAM_NAMES"][0],
                                                    secondTeamName:
                                                        match["TEAM_NAMES"][1],
                                                    tournamentId:
                                                        widget.tournamentId,
                                                    MATCH_ID: int.parse(
                                                        match["MATCH_ID"]))));
                                  }
                                },
                                child: const Text("Next"),
                              ),
                            )
                          ],
                        ),
                      )
                      .toList(),
                )),
              ) //here,
            ],
          ),
        ),
      ),
    );
  }
}
