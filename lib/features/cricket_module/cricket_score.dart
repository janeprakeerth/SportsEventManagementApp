// line 1122 should fix the index out of bound error

import 'dart:convert';
import 'package:ardent_sports/features/cricket_module/MatchResult.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ardent_sports/features/cricket_module/cricket_stricker_and_non_stricker_details.dart';
import 'package:socket_io_client/socket_io_client.dart';

class CricketScore extends StatefulWidget {
  final int overs;
  final int wickets;
  final bool first;
  final List<dynamic> battingTeam;
  final List<dynamic> ballingTeam;
  final dynamic striker;
  final dynamic non_striker;
  final dynamic baller;
  final String battingTeamName;
  final String bowlingTeamName;
  final String tournamentId;
  final String tossWonBy;
  final String tossWinnerChoseTo;
  final List<dynamic> allBattingPlayers;
  final List<dynamic> allBallingPlayers;
  final int score;
  final double overs_done;
  final String over_string;
  final int MATCH_ID;
  final int wickets_taken;
  final int score_to_beat;
  const CricketScore(
      {Key? key,
      required this.overs,
      required this.ballingTeam,
      required this.battingTeam,
      required this.first,
      required this.wickets,
      required this.striker,
      required this.non_striker,
      required this.baller,
      required this.battingTeamName,
      required this.bowlingTeamName,
      required this.tournamentId,
      required this.tossWonBy,
      required this.tossWinnerChoseTo,
      required this.allBattingPlayers,
      required this.allBallingPlayers,
      required this.MATCH_ID,
      required this.over_string,
      required this.overs_done,
      required this.score,
      required this.wickets_taken,
        required this.score_to_beat
      })
      : super(key: key);

  //DO INIT STATE
  get btnVal => "0";
  @override
  State<CricketScore> createState() => _CricketScoreState();
}

String? strikerName;
String? nonStrikerName;
bool _currentStriker = false;
bool _currentNonStriker = true;
var _currentOver;
var _currentMatchScore;
var _currentStrikerScore = 0;
var _currentWickets = 0;
var _currentNonStrikerScore = 0;
var _currentStrickerBallcount = 0;
var _currentNonStrickerBallcount = 0;
double? _currentBalleOver;
int _currentBowlingCount = 0;
bool allowLastmanPostion = true;
List<String> bowlerList = [];
bool matchInning = false;
var matchInningCount = 0;
bool setButtonDisable = false;
var curr_bowler_name;
List<String> WicketsType = [
  'LBW',
  'Bowled',
  'Catch Out',
  'Stricker Run Out',
  'Non-Stricker Run Out',
  'Stumped',
  'Hit Wicket'
];
var ways = {
  "LBW": "LBW",
  "Bowled": "B",
  "Catch Out": "C",
  "Stricker Run Out": "RO",
  "Non-Stricker Run Out": "RO",
  "Stumped": "ST",
  "Hit Wicket": "HW",
  "No Ball": "NB",
  "Wide Ball": "WD",
  "Bye Ball": "Bye"
};

class _CricketScoreState extends State<CricketScore> {
  var finalBattingTeam;
  var finalBallingTeam;
  var nowStriker;
  var nowNonStriker;
  var nowBaller;
  late Socket socket;

  @override
  void initState() {
    super.initState();
    print("Total score to beat ${widget.score_to_beat}");
    _currentBalleOver = 0.0;
    List<String> b = [];
    for (int i = 0; i < widget.ballingTeam.length; i++) {
      b.add(widget.ballingTeam[i]["NAME"]);
    }
    print(widget.allBallingPlayers);
    bowlerList = b;
    _currentStriker = true;
    _currentNonStriker = false;
    print(widget.striker["NAME"]);
    curr_bowler_name = widget.baller["NAME"];
    strikerName = widget.striker["NAME"];
    nonStrikerName = widget.non_striker["NAME"];
    finalBattingTeam = widget.battingTeam;
    finalBallingTeam = widget.ballingTeam;
    nowStriker = widget.striker;
    nowNonStriker = widget.non_striker;
    nowBaller = widget.baller;
    matchInning = widget.first;
    setButtonDisable = false;
    socket = io(
        "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000",
        <String, dynamic>{
          "transports": ["websocket"],
          "autoConnect": false,
          "forceNew": true,
        });
    socket.connect();
    socket.onConnect((data) => print("Connected"));
    print("First");
    print(widget.first);
    print("pARTH");
    // print(widget.score);
    _currentOver = widget.over_string;
    _currentMatchScore = widget.score;
    print(_currentMatchScore);
    _currentStrikerScore = widget.striker["SCORE"] ?? 0;
    _currentNonStrikerScore = widget.non_striker["SCORE"] ?? 0;
    _currentWickets = widget.wickets_taken;
    _currentStrickerBallcount = widget.striker["BALLS"];
    _currentNonStrickerBallcount = widget.non_striker["BALLS"];

    _currentBalleOver = widget.overs_done;
    _currentBalleOver =
        double.tryParse(_currentBalleOver?.toStringAsFixed(1) ?? "0.0");
    print(_currentBalleOver);
    print(widget.overs_done);
    print(_currentBalleOver! - _currentBalleOver!.toInt());
    _currentBowlingCount =
        (((_currentBalleOver! - _currentBalleOver!.toInt()) * 10).ceil())
            .toInt();
    curr_bowler_name = widget.baller["NAME"];
    print("Jod Jod");
    print(_currentBowlingCount);
    var sendData = {
      "TOURNAMENT_ID": widget.tournamentId,
      "MATCH_ID": widget.MATCH_ID
    };
    socket.emit('join-scoring-live', sendData);

    if (widget.first == true) {
      print("Match Inning Count");
      matchInningCount = 1;
      print(widget.first);
      print(matchInningCount);
      socket.emit('update-change-inning',
          {'TOURNAMENT_ID': widget.tournamentId, 'MATCH_ID': widget.MATCH_ID});
    } else{
      matchInningCount = 0;
      print(widget.first);
    }
    print(matchInningCount);
  }

  final TextEditingController _searchInputControllor = TextEditingController();

  void appendCharacters() {
    String oldText = _searchInputControllor.text;
    String newText = oldText + widget.btnVal;

    var newValue = _searchInputControllor.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newText.length,
      ),
      composing: TextRange.empty,
    );

    _searchInputControllor.value = newValue;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> change_strike() async {
      var url =
          "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/changeStrike";
      var sendJSON = jsonEncode(
          {"TOURNAMENT_ID": widget.tournamentId, "MATCH_ID": widget.MATCH_ID});
      socket.emit('update-change-strike',
          {"TOURNAMENT_ID": widget.tournamentId, "MATCH_ID": widget.MATCH_ID});
      print("Socket Called for Strike Change");

      var resp = await post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: sendJSON);
      print(resp.body);
      setState(() {
        _currentNonStriker = !_currentNonStriker;
        _currentStriker = !_currentStriker;
      });
    }

    Future<void> endMatch() async {
      var jsonData = jsonEncode({
        "TOURNAMENT_ID": widget.tournamentId,
        "batting_team_name": widget.battingTeamName,
        "MATCH_ID": widget.MATCH_ID
      });
      print("The json data is: " + jsonData.toString());
      var url =
          "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/endMatchCricket";
      socket.emit('end-match',
          {"TOURNAMENT_ID": widget.tournamentId, "MATCH_ID": widget.MATCH_ID});
      var response = await post(Uri.parse(url),
          body: jsonData, headers: {"Content-Type": "application/json"});
      print("😁😁response For End Match is : " + response.body);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => SimpleDialog(
                  title: const Center(
                      child: Text(
                    'Match Over',
                    style: TextStyle(color: Colors.red),
                  )),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Match Completed View Result"),
                    ),
                    ButtonBar(
                      children: [
                        ElevatedButton(
                          onPressed: () async{

                            var url =
                                "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/getScoreCard";
                            var data = jsonEncode(
                                {"TOURNAMENT_ID": widget.tournamentId, "MATCH_ID": widget.MATCH_ID});
                            var response = await post(Uri.parse(url),
                                body: data, headers: {"Content-Type": "application/json"});
                            var allData = jsonDecode(response.body);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MatchResult(
                                        TOURNAMENT_ID: widget.tournamentId,
                                        MATCH_ID: widget.MATCH_ID,
                                        allData : allData
                                    )));
                          },
                          child: const Text("Ok"),
                        ),
                      ],
                    )
                  ]));
    }

    Future<void> changeInning() async {
      if (matchInningCount == 0) {
        setState(() {
          matchInningCount += 1;
        });
        print("Now match Inning is $matchInningCount");
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => SimpleDialog(
              title: const Center(
                  child: Text('Innings Over',
                      style: TextStyle(color: Colors.red))),
              children: <Widget>[
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        var url =
                            "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/changeInningCricket";
                        var inningsJson = {
                          "TOURNAMENT_ID": widget.tournamentId,
                          "MATCH_ID": widget.MATCH_ID
                        };
                        var inningsJsonData = jsonEncode(inningsJson);
                        print("The json data is: " + inningsJson.toString());
                        var response = await post(Uri.parse(url),
                            body: inningsJsonData,
                            headers: {"Content-Type": "application/json"});
                        print("😌😌 response from innings change api is: " +
                            response.body);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CricketStrickerAndNonStrickerDetails(
                                      tournamentId: widget.tournamentId,
                                      battingTeamName: widget.bowlingTeamName,
                                      bowlingTeamName: widget.battingTeamName,
                                      overs: widget.overs,
                                      wickets: widget.wickets,
                                      first: true,
                                      tossWonBy: widget.tossWonBy,
                                      tossWinnerChoseTo:
                                          widget.tossWinnerChoseTo,
                                      battingTeamPlayers:
                                          widget.allBallingPlayers,
                                      bowlingTeamPlayers:
                                          widget.allBattingPlayers,
                                      MATCH_ID: widget.MATCH_ID,
                                      score_to_beat : _currentMatchScore,
                                    )));
                      },
                      child: const Text("Change Innings"),
                    ),
                  ],
                ),
              ]),
        );
      } else {
        //end matc
        await endMatch();
      }
    }

    Future<void> change_over() async {
      double h = MediaQuery.of(context).size.height;
      double w = MediaQuery.of(context).size.width;
      print("Over Change was called : ");
      print("But balling count is : ");
      print(_currentBowlingCount);
      if (_currentBowlingCount == 6) {
        //increment overs count
        print("So over change : ");
        setState(() {
          _currentNonStriker = !_currentNonStriker;
          _currentStriker = !_currentStriker;
          _currentOver = "";
          _currentBalleOver = (_currentBalleOver! + 0.4).toDouble();
          _currentBalleOver =
              double.tryParse(_currentBalleOver?.toStringAsFixed(1) ?? "0.0");
          _currentBowlingCount = 0;
        });

        print("After over change set state : ");
        print(_currentOver);
        print(_currentBalleOver);
        print(_currentBowlingCount);
        if (_currentBalleOver?.toInt() == widget.overs) {
          await changeInning();
        } else {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text("Choose Bowler"),
                    content: Container(
                      height: h * 0.3,
                      width: w * 0.3,
                      child: ListView.builder(
                        itemCount: bowlerList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(bowlerList[index]),
                            onTap: () async {
                              setState(() {
                                curr_bowler_name = bowlerList[index];
                              });
                              var Overjson = {
                                "TOURNAMENT_ID": widget.tournamentId,
                                "baller_index": widget.allBallingPlayers
                                    .where((element) =>
                                        element["NAME"] == bowlerList[index])
                                    .toList()[0]["index"],
                                "MATCH_ID": widget.MATCH_ID
                              };

                              // make api call to change over
                              var url =
                                  "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/changeOverCricket";

                              var jsonData = jsonEncode(Overjson);
                              print("The json data is: " + Overjson.toString());
                              var response = await post(Uri.parse(url),
                                  body: jsonData,
                                  headers: {
                                    "Content-Type": "application/json"
                                  });
                              print("😁😁response For over change is : " +
                                  response.body);
                              print(Overjson);
                              socket.emit("update-over-changed", Overjson);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ));
        }
      }
    }

    Future<void> scoreRun(int run) async {
      var sendData1 = {
        "TOURNAMENT_ID": widget.tournamentId,
        "SCORE": run,
        "MATCH_ID": widget.MATCH_ID
      };
      socket.emit('update-usual-score', sendData1);

      var url =
          "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/usualScore";
      var sendData = {
        "TOURNAMENT_ID": widget.tournamentId,
        "score": run.toString(),
        "MATCH_ID": widget.MATCH_ID
      };
      var jsonData = jsonEncode(sendData);
      var response = await post(Uri.parse(url),
          body: jsonData, headers: {"Content-Type": "application/json"});
      print("Adding Score");
      print(response.body);

      setState(() {
        _currentOver += run.toString() + "-";
        _currentMatchScore += run;
        _currentBalleOver = _currentBalleOver! + 0.1;
        _currentBalleOver =
            double.tryParse(_currentBalleOver?.toStringAsFixed(1) ?? "0.0");
        _currentBowlingCount += 1;
      });
      if (_currentStriker) {
        setState(() {
          _currentStrikerScore += run;
          _currentStrickerBallcount += 1;
        });
      } else {
        setState(() {
          _currentNonStrikerScore += run;
          _currentNonStrickerBallcount += 1;
        });
      }
      if (run % 2 == 1) {
        setState(() {
          _currentStriker = !_currentStriker;
          _currentNonStriker = !_currentNonStriker;
        });
      }
      change_over();
      if(_currentMatchScore > widget.score_to_beat){
        await changeInning();
      }
    }

    Future<void> specialRuns(int run, String reason) async {
      var url =
          "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/specialRuns";
      var sendData = jsonEncode({
        "TOURNAMENT_ID": widget.tournamentId,
        "score": run,
        "remarks": reason,
        "MATCH_ID": widget.MATCH_ID
      });
      print("Emitting Socket");
      socket.emit('update-special-runs', {
        "TOURNAMENT_ID": widget.tournamentId,
        "score": run,
        "remarks": reason,
        "MATCH_ID": widget.MATCH_ID
      });
      var resp = await post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: sendData);
      print(resp.body);

      setState(() {
        _currentOver += (ways[reason]! + "-");
        _currentMatchScore += (run);

        if (reason != "Bye Ball") {
          _currentMatchScore += 1;
        } else {
          _currentBowlingCount += 1;
          _currentBalleOver = _currentBalleOver! + 0.1;
          _currentBalleOver =
              double.tryParse(_currentBalleOver?.toStringAsFixed(1) ?? "0.0");
        }
        if (_currentStriker) {
          _currentStrikerScore += run;
        } else {
          _currentNonStrikerScore += run;
        }
      });
      if (run % 2 == 1) {
        _currentNonStriker = !_currentNonStriker;
        _currentStriker = !_currentStriker;
      }
      print("Current Over Count ");
      print(_currentBalleOver);
      print("Current Bowling Count ");
      print(_currentBowlingCount);
      await change_over();
      if(_currentMatchScore > widget.score_to_beat){
        await changeInning();
      }
    }

    Future<void> out_manage(String wickets, int e) async {

      if(_currentWickets <= widget.wickets - 2){
        setState(() {
          _currentBowlingCount += 1;
          _currentBalleOver = _currentBalleOver! + 0.1;
          _currentBalleOver =
              double.tryParse(_currentBalleOver?.toStringAsFixed(1) ?? "0.0");
          _currentOver += ("${ways[wickets]}-");
          _currentWickets += 1;
          if (wickets != "Non-Stricker Run Out") {
            if (_currentStriker) {
              strikerName = widget.allBattingPlayers[e as int]["NAME"];
              // reset the striker score and ball count
              _currentStrikerScore = 0;
              _currentStrickerBallcount = 0;
            } else {
              nonStrikerName = widget.allBattingPlayers[e as int]["NAME"];
              // reset the non striker score and ball count
              _currentNonStrikerScore = 0;
              _currentNonStrickerBallcount = 0;
            }
          } else {
            if (_currentStriker) {
              nonStrikerName = widget.allBattingPlayers[e as int]["NAME"];
              // reset the non striker score and ball count
              _currentNonStrikerScore = 0;
              _currentNonStrickerBallcount = 0;
            } else {
              strikerName = widget.allBattingPlayers[e as int]["NAME"];
              // reset the striker score and ball count
              _currentStrikerScore = 0;
              _currentStrickerBallcount = 0;
            }
          }
        });
        await change_over();
        print("New batsman is : ");
        print(widget.allBattingPlayers[e]);
        var outURL =
            "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/outScore";
        var outJson = {
          "TOURNAMENT_ID": widget.tournamentId,
          "index": widget.allBattingPlayers[e]["index"],
          "remarks": wickets,
          "MATCH_ID": widget.MATCH_ID
        };
        socket.emit('update-out', outJson);
        print("The json is $outJson");
        var outJsonData = jsonEncode(outJson);
        var outResponse = await post(Uri.parse(outURL),
            headers: {"Content-Type": "application/json"}, body: outJsonData);
        print("The response for the out api is ${outResponse.body}");

      } else{
        await changeInning();
      }
      Navigator.pop(context);
    }

    //THIS JUST SHOWS CURRENT BATTING TEAM NAME.. NO CONDITIONS TO CHECK
    //correct
    _header() {
      double h = MediaQuery.of(context).size.height;
      double w = MediaQuery.of(context).size.height;
      return Positioned(
        left: 0.08,
        right: 0.08,
        top: h * 0.1,
        child: Container(
            height: h * 0.12,
            decoration:
                const BoxDecoration(color: Color.fromARGB(154, 95, 96, 95)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(w * 0.02),
                    child: Text(
                      widget.battingTeamName,
                      style: TextStyle(
                          fontSize: w * 0.03,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(w * 0.01),
                  ),
                ])),
      );
    }

    //just display no of overs done and and total overs
    //correct
    _score() {
      double h = MediaQuery.of(context).size.height;
      double w = MediaQuery.of(context).size.width;
      return Positioned(
        top: h * 0.3,
        left: w * 0.65,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: w * 0.02),
              child: Padding(
                padding: EdgeInsets.all(w * 0.02),
                child: Text(
                    "(${(_currentBalleOver)?.toStringAsFixed(1)})/${widget.overs}",
                    style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    }

    //just to display current match score and wickets taken.
    //checked
    _batsmanScore() {
      double h = MediaQuery.of(context).size.height;
      double w = MediaQuery.of(context).size.width;
      return Positioned(
        top: h * 0.27,
        left: w * 0.3,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: w * 0.02),
              child: Padding(
                padding: EdgeInsets.all(w * 0.02),
                child: Text("($_currentMatchScore/$_currentWickets)",
                    style: TextStyle(
                        fontSize: w * 0.1,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    }

    //displaying striker and non-striker
    //when ui is clicked, api for strike change is called
    //checked
    _scoreCard() {
      double h = MediaQuery.of(context).size.height;
      double w = MediaQuery.of(context).size.width;
      return Positioned(
        top: h * 0.48,
        left: h * 0.02,
        right: w * 0.04,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ElevatedButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                      child: Column(children: <Widget>[
                    SizedBox(height: h * 0.01),
                    Row(children: [Text(strikerName ?? "Striker Name")]),
                    SizedBox(height: h * 0.01),
                    Row(children: [
                      Text(
                        "$_currentStrikerScore",
                        style: TextStyle(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      Text(
                        "($_currentStrickerBallcount)",
                        style: TextStyle(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(height: h * 0.01),
                    ]),
                  ])),
                  SizedBox(width: w * 0.02),
                  (_currentStriker)
                      ? Image(
                          width: w * 0.07,
                          height: h * 0.07,
                          image: const NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/8258/8258931.png'),
                        )
                      : Container(),
                ]),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 60),
                maximumSize: const Size(150, 60),
                elevation: 5,
                backgroundColor: const Color.fromRGBO(255, 255, 255, 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w * 0.02),
                )),
            onPressed: () async {
              await change_strike();
            },
          ),
          ElevatedButton(
            child: Row(children: [
              Center(
                  child: Column(children: <Widget>[
                SizedBox(height: h * 0.01),
                Row(children: [Text(nonStrikerName ?? "Non Striker")]),
                SizedBox(height: h * 0.01),
                Row(children: [
                  Text(
                    "$_currentNonStrikerScore",
                    style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    "($_currentNonStrickerBallcount)",
                    style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(height: h * 0.01),
                ]),
              ])),
              SizedBox(width: w * 0.02),
              (_currentNonStriker)
                  ? Image(
                      width: w * 0.07,
                      height: h * 0.07,
                      image: const NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/8258/8258931.png'),
                    )
                  : Container()
            ]),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 60),
                maximumSize: const Size(150, 60),
                elevation: 5,
                backgroundColor: const Color.fromRGBO(255, 255, 255, 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w * 0.02),
                )),
            onPressed: () async {
              await change_strike();
            },
          ),
        ]),
      );
    }

    //display bowler name, and current_over details
    //checked
    _bowlerCard() {
      double h = MediaQuery.of(context).size.height;
      double w = MediaQuery.of(context).size.width;
      return Positioned(
        top: h * 0.56,
        left: h * 0.02,
        right: w * 0.04,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image(
                  width: w * 0.1,
                  height: h * 0.1,
                  image: const NetworkImage(
                      'https://cdn.iconscout.com/icon/premium/png-256-thumb/cricket-ball-2574544-2171281.png'),
                ),
                Text(
                  curr_bowler_name,
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  _currentOver,
                  style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.5),
                ))
          ],
        ),
      );
    }

    //for 0, 1 , 2
    _keyBoard() {
      double h = MediaQuery.of(context).size.height;
      double w = MediaQuery.of(context).size.width;
      return Positioned(
        top: h * 0.65,
        left: w * 0.01,
        right: w * 0.01,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              width: w * 0.2,
              height: w * 0.15,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ElevatedButton(
                  child: const Text("0"),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * 0.02),
                      ),
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    await scoreRun(0);
                  })),
          SizedBox(
              width: w * 0.2,
              height: w * 0.15,
              child: ElevatedButton(
                child: const Text("1"),
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.02),
                    )),
                onPressed: () async {
                  await scoreRun(1);
                },
              )),
          SizedBox(
              width: w * 0.2,
              height: w * 0.15,
              child: ElevatedButton(
                child: const Text("2"),
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.02),
                    )),
                onPressed: () async {
                  await scoreRun(2);
                },
              )),
          SizedBox(
              width: w * 0.2,
              height: w * 0.15,
              child: Container()) //ElevatedButton(
        ]),
      );
    }

    //3,4,6,5
    _keyBoard2() {
      double h = MediaQuery.of(context).size.height;
      double w = MediaQuery.of(context).size.width;
      return Positioned(
        top: h * 0.74,
        left: w * 0.01,
        right: w * 0.01,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
              width: w * 0.2,
              height: w * 0.15,
              child: ElevatedButton(
                child: const Text("3"),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.02),
                    ),
                    backgroundColor: Colors.red),
                onPressed: () async {
                  await scoreRun(3);
                },
              )),
          SizedBox(
              width: w * 0.2,
              height: w * 0.15,
              child: ElevatedButton(
                child: const Text("4"),
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.02),
                    )),
                onPressed: () async {
                  await scoreRun(4);
                },
              )),
          SizedBox(
              width: w * 0.2,
              height: w * 0.15,
              child: ElevatedButton(
                child: const Text("6"),
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.02),
                    )),
                onPressed: () async {
                  await scoreRun(6);
                },
              )),
          SizedBox(
              width: w * 0.2,
              height: w * 0.15,
              child: ElevatedButton(
                child: const Text("5"),
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.02),
                    )),
                onPressed: () async => {
                  await scoreRun(5),
                },
              )),
        ]),
      );
    }

    //to be done
    _keyBoard3() {
      double h = MediaQuery.of(context).size.height;
      double w = MediaQuery.of(context).size.width;
      TextEditingController nbscore = TextEditingController();
      return Positioned(
        top: h * 0.83,
        left: w * 0.01,
        right: w * 0.01,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
              width: w * 0.2,
              height: w * 0.15,
              child: ElevatedButton(
                child: const Text("WD"),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.02),
                    ),
                    backgroundColor: Colors.red),
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => SimpleDialog(
                        title: const Text('Score'),
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                TextField(
                                  keyboardType: TextInputType.number,
                                  controller: nbscore,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextButton(
                                    onPressed: () async {
                                      print(nbscore.text);
                                      specialRuns(
                                          int.parse(nbscore.text), "Wide Ball");
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok"))
                              ]))
                        ]),
                  );
                },
              )),
          SizedBox(
              width: w * 0.2,
              height: w * 0.15,
              child: ElevatedButton(
                child: const Text("NB"),
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.02),
                    )),
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => SimpleDialog(
                        title: const Text('Score'),
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                TextField(
                                  keyboardType: TextInputType.number,
                                  controller: nbscore,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextButton(
                                    onPressed: () async {
                                      print(nbscore.text);
                                      specialRuns(
                                          int.parse(nbscore.text), "No Ball");
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok"))
                              ]))
                        ]),
                  );
                },
              )),
          SizedBox(
              width: w * 0.2,
              height: w * 0.15,
              child: ElevatedButton(
                child: const Text("BYE"),
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.02),
                    )),
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => SimpleDialog(
                        title: const Text('Score'),
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                TextField(
                                  keyboardType: TextInputType.number,
                                  controller: nbscore,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextButton(
                                    onPressed: () async {
                                      print(nbscore.text);
                                      specialRuns(
                                          int.parse(nbscore.text), "Bye Ball");
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok"))
                              ]))
                        ]),
                  );
                },
              )),
          //Before OUT everything is checked to be working
          SizedBox(
              width: w * 0.2,
              height: w * 0.15,
              child: ElevatedButton(
                child: const Text(
                  "Out",
                  style: TextStyle(color: Colors.red),
                ),
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.02),
                    )),
                onPressed: () async {
                  if (_currentWickets == widget.wickets - 2) {
                    await changeInning();
                  } else {
                    setState(() {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => SimpleDialog(
                          title: const Text('Wicket Type'),
                          children: <Widget>[
                            for (String wickets in WicketsType)
                              SimpleDialogOption(
                                onPressed: () async {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) => SimpleDialog(
                                        title: const Text('New Player'),
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(children: [
                                                DropdownButtonFormField(
                                                  hint: Text((wickets ==
                                                          "Non-Stricker Run Out")
                                                      ? "Next Non-Striker"
                                                      : "Next Striker"),
                                                  items: widget.battingTeam
                                                      .map((e) =>
                                                          DropdownMenuItem(
                                                            child:
                                                                Text(e["NAME"]),
                                                            value: e["index"],
                                                          ))
                                                      .toList(),
                                                  onChanged: (e) async {
                                                    await out_manage(
                                                        wickets, e as int);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ]))
                                        ]),
                                  );
                                  await change_over();
                                },
                                child: Text(wickets),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 30,
                                  width: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Done",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color.fromARGB(
                                            255, 54, 181, 244)),
                                  ),
                                ))
                          ],
                        ),
                      );
                    });
                  }
                },
              )),
        ]),
      );
    }

    // _submit() {
    //   var h = MediaQuery.of(context).size.height;
    //   var w = MediaQuery.of(context).size.width;
    //
    //   return Positioned(
    //       top: h * 0.92,
    //       left: w * 0.2,
    //       child: Center(
    //         child: ElevatedButton(
    //           style: ElevatedButton.styleFrom(
    //               elevation: 5,
    //               backgroundColor: const Color(0xFFD15858),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(w * 0.02),
    //               )),
    //           onPressed: () {
    //             setState(() {
    //               _currentOver = "";
    //               _currentMatchScore = 0;
    //               _currentStrikerScore = 0;
    //               _currentNonStrikerScore = 0;
    //               _currentStrickerBallcount = 0;
    //               _currentNonStrickerBallcount = 0;
    //               _currentStriker = true;
    //               _currentNonStriker = false;
    //               _currentBalleOver = 0.0;
    //               _currentBalleOver = double.tryParse(_currentBalleOver?.toStringAsFixed(1)??"0.0");
    //               _currentWickets = 0;
    //               _currentBowlingCount = 0;
    //             });
    //           },
    //         ),
    //       ));
    // }

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: SizedBox(
        height: h,
        child: Stack(
          children: [
            Positioned(
              top: h * 0.03,
              left: w * 0.01,
              child: TextButton(
                child: Text(
                  "<",
                  style: TextStyle(
                      fontSize: w * 0.09,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            _header(),

            _batsmanScore(),
            _score(),
            Positioned(
              top: h * 0.42,
              left: w * 0.11,
              child: Text(
                "${widget.tossWonBy} won the toss and elected to ${widget.tossWinnerChoseTo} first",
                style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
            // _score(),
            _scoreCard(),
            _bowlerCard(),
            _keyBoard(),
            _keyBoard2(),
            _keyBoard3(),
            // _submit(),
          ],
        ),
      )),
    );
  }
}

//!CR179543-CR-NA
