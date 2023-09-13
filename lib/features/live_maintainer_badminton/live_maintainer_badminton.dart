// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:ardent_sports/LiveMaintainerMatchSelection.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../home_page/home_page.dart';
import '../../helper/apis.dart';

var update_score_1_first = 0;
var update_score_1_second = 0;
var update_score_2_first = 0;
var update_score_2_second = 0;
var update_score_3_first = 0;
var update_score_3_second = 0;

late Socket socket;

class player_score {
  late final int set1;
  late final int set2;
  late final int set3;
}

class Details_LiveMaintainer {
  late String entity;
  late String entity_ID;
  late String TOURNAMENT_ID;
  late String MATCHID;
  Details_LiveMaintainer({
    required this.entity,
    required this.entity_ID,
    required this.TOURNAMENT_ID,
    required this.MATCHID,
  });
  Map<String, dynamic> toMap() {
    return {
      "entity": entity,
      "entity_ID": entity_ID,
      "TOURNAMENT_ID": TOURNAMENT_ID,
      "MATCHID": MATCHID,
    };
  }
}

class Score_LiveMaintainer {
  late String PLAYER_1_SCORE;
  late String PLAYER_2_SCORE;
  late String set;
  Score_LiveMaintainer({
    required this.PLAYER_1_SCORE,
    required this.PLAYER_2_SCORE,
    required this.set,
  });
  Map<String, dynamic> toMap() {
    return {
      "PLAYER_1_SCORE": PLAYER_1_SCORE,
      "PLAYER_2_SCORE": PLAYER_2_SCORE,
      "set": set,
    };
  }
}

class WalkOver {
  WalkOver({
    required this.TOURNAMENTID,
    required this.MATCHID,
    required this.WINNER_ID,
  });
  late final String TOURNAMENTID;
  late final String MATCHID;
  late final String WINNER_ID;

  WalkOver.fromJson(Map<String, dynamic> json) {
    TOURNAMENTID = json['TOURNAMENT_ID'];
    MATCHID = json['MATCHID'];
    WINNER_ID = json['WINNNER_ID'];
  }

  Map<String, dynamic> toMap() {
    return {
      "TOURNAMENT_ID": TOURNAMENTID,
      "MATCHID": MATCHID,
      "WINNER_ID": WINNER_ID,
    };
  }
}

class LiveMaintainer extends StatefulWidget {
  final String Tournament_ID;
  final String Match_Id;
  final String Player_1_name;
  final String Player1_Partner;
  final String Player_2_name;
  final String Player2_Partner;
  final String Player1_ID;
  final String Player2_ID;
  final int player1_set_1;
  final int player1_set_2;
  final int player1_set_3;
  final int player2_set_1;
  final int player2_set_2;
  final int player2_set_3;
  const LiveMaintainer({
    Key? key,
    required this.Tournament_ID,
    required this.Match_Id,
    required this.Player_1_name,
    required this.Player1_Partner,
    required this.Player_2_name,
    required this.Player2_Partner,
    required this.Player1_ID,
    required this.Player2_ID,
    required this.player1_set_1,
    required this.player1_set_2,
    required this.player1_set_3,
    required this.player2_set_1,
    required this.player2_set_2,
    required this.player2_set_3,
  }) : super(key: key);
  @override
  LiveMaintainer1 createState() => LiveMaintainer1();
}

class LiveMaintainer1 extends State<LiveMaintainer> {
  @override
  void initState() {
    super.initState();
    socket = io(
        "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000",
        <String, dynamic>{
          "transports": ["websocket"],
          "autoConnect": false,
          "forceNew": true,
        });
    socket.connect();
    socket.onConnect((data) => print("Connected"));

    final details = Details_LiveMaintainer(
      entity: "LIV",
      entity_ID: "shubro18@gmail.com",
      TOURNAMENT_ID: widget.Tournament_ID,
      MATCHID: widget.Match_Id,
    );
    final detailsmap = details.toMap();
    final json_details = jsonEncode(detailsmap);
    socket.emit('join-room', json_details);
    print(socket.connected);
  }

  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    print("deviceWidth : ${deviceWidth}");
    print("deviceHeight : ${deviceHeight}");
    return WillPopScope(
      onWillPop: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Back Alert"),
            content: const Text("Are you sure you want to go back?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  child: const Text(
                    "NO",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LiveMaintainerMatchSelection(
                                Tournament_id: widget.Tournament_ID,
                              )));
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  child:
                      const Text("YES", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/Homepage.png"),
                      fit: BoxFit.cover)),
              child: SafeArea(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        height: deviceHeight * 0.60,
                        width: deviceWidth * 0.95,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.08),
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          color: Colors.white.withOpacity(0.2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 15.0,
                              ),
                              Center(
                                child: Text(
                                  "Enter Score",
                                  style: TextStyle(
                                    color: Color(0xffE74545),
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24.0,
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceWidth * 0.027777)),
                                color: Color(0xff252626),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 240,
                                      child: Card(
                                        color: Color(0xff252626),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: 60,
                                              child: Card(
                                                color: Color(0xff252626),
                                              ),
                                            ),
                                            Center(
                                              child: IconButton(
                                                icon: Image.asset(
                                                    'assets/edit_button.png'),
                                                onPressed: () {
                                                  print("1");
                                                  update_score_1_first =
                                                      widget.player1_set_1;
                                                  update_score_1_second =
                                                      widget.player2_set_1;
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Editbutton1(
                                                          Tournament_Id: widget
                                                              .Tournament_ID,
                                                          Match_Id:
                                                              widget.Match_Id,
                                                          Player_1_name: widget
                                                              .Player_1_name,
                                                          Player_2_name: widget
                                                              .Player_2_name,
                                                          Player1_Partner: widget
                                                              .Player1_Partner,
                                                          Player2_Partner: widget
                                                              .Player2_Partner,
                                                          player1_set_1: widget
                                                              .player1_set_1,
                                                          player1_set_2: widget
                                                              .player1_set_2,
                                                          player1_set_3: widget
                                                              .player1_set_3,
                                                          player2_set_1: widget
                                                              .player2_set_1,
                                                          player2_set_2: widget
                                                              .player2_set_2,
                                                          player2_set_3: widget
                                                              .player2_set_3,
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                            Center(
                                              child: IconButton(
                                                icon: Image.asset(
                                                    'assets/edit_button.png'),
                                                onPressed: () {
                                                  update_score_2_first =
                                                      widget.player1_set_2;
                                                  update_score_2_second =
                                                      widget.player2_set_2;
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Editbutton2(
                                                          Tournament_ID: widget
                                                              .Tournament_ID,
                                                          Match_Id:
                                                              widget.Match_Id,
                                                          Player_1_name: widget
                                                              .Player_1_name,
                                                          Player_2_name: widget
                                                              .Player_2_name,
                                                          Player1_Partner: widget
                                                              .Player1_Partner,
                                                          Player2_Partner: widget
                                                              .Player2_Partner,
                                                          player1_set_1: widget
                                                              .player1_set_1,
                                                          player1_set_2: widget
                                                              .player1_set_2,
                                                          player1_set_3: widget
                                                              .player1_set_3,
                                                          player2_set_1: widget
                                                              .player2_set_1,
                                                          player2_set_2: widget
                                                              .player2_set_2,
                                                          player2_set_3: widget
                                                              .player2_set_3,
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                            Center(
                                              child: IconButton(
                                                icon: Image.asset(
                                                    'assets/edit_button.png'),
                                                onPressed: () {
                                                  update_score_3_first =
                                                      widget.player1_set_3;
                                                  update_score_3_second =
                                                      widget.player2_set_3;
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Editbutton3(
                                                          Tournament_ID: widget
                                                              .Tournament_ID,
                                                          Match_Id:
                                                              widget.Match_Id,
                                                          Player_1_name: widget
                                                              .Player_1_name,
                                                          Player_2_name: widget
                                                              .Player_2_name,
                                                          Player1_Partner: widget
                                                              .Player1_Partner,
                                                          Player2_Partner: widget
                                                              .Player2_Partner,
                                                          player1_set_1: widget
                                                              .player1_set_1,
                                                          player1_set_2: widget
                                                              .player1_set_2,
                                                          player1_set_3: widget
                                                              .player1_set_3,
                                                          player2_set_1: widget
                                                              .player2_set_1,
                                                          player2_set_2: widget
                                                              .player2_set_2,
                                                          player2_set_3: widget
                                                              .player2_set_3,
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    SizedBox(
                                      width: 125,
                                      height: 240,
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: Colors.white.withOpacity(0.2),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 112,
                                              height: 60,
                                              child: Card(
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                color: Color(0xff252626),
                                                child: Center(
                                                  child: Text(
                                                      "${widget.Player_1_name}\n${widget.Player1_Partner}"),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "${widget.player1_set_1}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25.0,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "${widget.player1_set_2}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25.0,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "${widget.player1_set_3}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25.0,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 17,
                                    ),
                                    SizedBox(
                                      width: 125,
                                      height: 240,
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: Colors.white.withOpacity(0.2),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 112,
                                              height: 60,
                                              child: Card(
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                color: Color(0xff252626),
                                                child: Center(
                                                  child: Text(
                                                      "${widget.Player_2_name}\n${widget.Player2_Partner}"),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "${widget.player2_set_1}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25.0,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "${widget.player2_set_2}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25.0,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "${widget.player2_set_3}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25.0,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 350,
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xffD15858),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        if ((widget.player1_set_1 >
                                                    widget.player2_set_1 &&
                                                widget.player1_set_2 >
                                                    widget.player2_set_2) ||
                                            (widget.player1_set_1 >
                                                    widget.player2_set_1 &&
                                                widget.player1_set_3 >
                                                    widget.player2_set_3) ||
                                            (widget.player1_set_2 >
                                                    widget.player2_set_2 &&
                                                widget.player1_set_3 >
                                                    widget.player2_set_3)) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Submit(
                                                        MatchId:
                                                            widget.Match_Id,
                                                        Tournament_ID: widget
                                                            .Tournament_ID,
                                                        p1_name: widget
                                                            .Player_1_name,
                                                        p1_partner_name: widget
                                                            .Player1_Partner,
                                                        p2_name: widget
                                                            .Player_2_name,
                                                        p2_partner_name: widget
                                                            .Player2_Partner,
                                                        player1_set_1: widget
                                                            .player1_set_1,
                                                        player1_set_2: widget
                                                            .player1_set_2,
                                                        player1_set_3: widget
                                                            .player1_set_3,
                                                        player2_set_1: widget
                                                            .player2_set_1,
                                                        player2_set_2: widget
                                                            .player2_set_2,
                                                        player2_set_3: widget
                                                            .player2_set_3,
                                                      )));
                                        } else {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Submit(
                                                        MatchId:
                                                            widget.Match_Id,
                                                        Tournament_ID: widget
                                                            .Tournament_ID,
                                                        p1_name: widget
                                                            .Player_1_name,
                                                        p1_partner_name: widget
                                                            .Player1_Partner,
                                                        p2_name: widget
                                                            .Player_2_name,
                                                        p2_partner_name: widget
                                                            .Player2_Partner,
                                                        player1_set_1: widget
                                                            .player1_set_1,
                                                        player1_set_2: widget
                                                            .player1_set_2,
                                                        player1_set_3: widget
                                                            .player1_set_3,
                                                        player2_set_1: widget
                                                            .player2_set_1,
                                                        player2_set_2: widget
                                                            .player2_set_2,
                                                        player2_set_3: widget
                                                            .player2_set_3,
                                                      )));
                                        }
                                      },
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                widget.Player_1_name != 'N/A'
                                                    ? Color(0xffD15858)
                                                    : Color(0xff808080),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Text("Walk Over Player 1"),
                                          onPressed: () async {
                                            if (widget.Player_1_name != 'N/A') {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                        title: Text(
                                                            "Confirmation"),
                                                        content: Text(
                                                            "${widget.Player_1_name} will be declared as Winner!"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              final walkOver = WalkOver(
                                                                  MATCHID: widget
                                                                      .Match_Id,
                                                                  WINNER_ID: widget
                                                                      .Player1_ID,
                                                                  TOURNAMENTID:
                                                                      widget
                                                                          .Tournament_ID);

                                                              final walkOverMap =
                                                                  walkOver
                                                                      .toMap();
                                                              final json =
                                                                  jsonEncode(
                                                                      walkOverMap);
                                                              EasyLoading.show(
                                                                  status:
                                                                      'loading...',
                                                                  maskType:
                                                                      EasyLoadingMaskType
                                                                          .black);
                                                              var response = await post(
                                                                  walkoverApi,
                                                                  headers: {
                                                                    "Content-Type":
                                                                        "application/json",
                                                                    "Accept":
                                                                        "application/json",
                                                                  },
                                                                  body: json,
                                                                  encoding: Encoding
                                                                      .getByName(
                                                                          "utf-8"));

                                                              final jsonResponse =
                                                                  jsonDecode(
                                                                      response
                                                                          .body);

                                                              if (jsonResponse[
                                                                      'Message'] ==
                                                                  'Success') {
                                                                EasyLoading
                                                                    .dismiss();
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              LiveMaintainerMatchSelection(
                                                                                Tournament_id: widget.Tournament_ID,
                                                                              )),
                                                                );
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg:
                                                                      "${widget.Player_1_name} has been declared as winner",
                                                                );
                                                              } else {
                                                                EasyLoading
                                                                    .dismiss();
                                                                Navigator.pop(
                                                                    context);
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Failed to do Walk Over");
                                                              }
                                                            },
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          )

                                                          // },
                                                        ],
                                                      ));
                                            }
                                          }),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                widget.Player_2_name != 'N/A'
                                                    ? Color(0xffD15858)
                                                    : Color(0xff808080),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Text("Walk Over Player 2"),
                                          onPressed: () async {
                                            if (widget.Player_2_name != 'N/A') {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                        title: Text(
                                                            "Confirmation"),
                                                        content: Text(
                                                            "${widget.Player_2_name} will be declared as Winner!"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              final walkOver = WalkOver(
                                                                  MATCHID: widget
                                                                      .Match_Id,
                                                                  WINNER_ID: widget
                                                                      .Player2_ID,
                                                                  TOURNAMENTID:
                                                                      widget
                                                                          .Tournament_ID);

                                                              final walkOverMap =
                                                                  walkOver
                                                                      .toMap();
                                                              final json =
                                                                  jsonEncode(
                                                                      walkOverMap);
                                                              EasyLoading.show(
                                                                  status:
                                                                      'loading...',
                                                                  maskType:
                                                                      EasyLoadingMaskType
                                                                          .black);
                                                              var response = await post(
                                                                  walkoverApi,
                                                                  headers: {
                                                                    "Content-Type":
                                                                        "application/json",
                                                                    "Accept":
                                                                        "application/json",
                                                                  },
                                                                  body: json,
                                                                  encoding: Encoding
                                                                      .getByName(
                                                                          "utf-8"));

                                                              final jsonResponse =
                                                                  jsonDecode(
                                                                      response
                                                                          .body);

                                                              if (jsonResponse[
                                                                      'Message'] ==
                                                                  'Success') {
                                                                EasyLoading
                                                                    .dismiss();
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              LiveMaintainerMatchSelection(
                                                                                Tournament_id: widget.Tournament_ID,
                                                                              )),
                                                                );
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg:
                                                                      "${widget.Player_2_name} has been declared as winner",
                                                                );
                                                              } else {
                                                                EasyLoading
                                                                    .dismiss();
                                                                Navigator.pop(
                                                                    context);
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Failed to do Walk Over");
                                                              }
                                                            },
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          )

                                                          // },
                                                        ],
                                                      ));
                                            }
                                          }),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class Editbutton1 extends StatefulWidget {
  final String Tournament_Id;
  final String Match_Id;
  final String Player_1_name;
  final String Player_2_name;
  final String Player1_Partner;
  final String Player2_Partner;
  final int player1_set_1;
  final int player1_set_2;
  final int player1_set_3;
  final int player2_set_1;
  final int player2_set_2;
  final int player2_set_3;
  const Editbutton1({
    Key? key,
    required this.Tournament_Id,
    required this.Match_Id,
    required this.Player_1_name,
    required this.Player_2_name,
    required this.Player1_Partner,
    required this.Player2_Partner,
    required this.player1_set_1,
    required this.player1_set_2,
    required this.player1_set_3,
    required this.player2_set_1,
    required this.player2_set_2,
    required this.player2_set_3,
  }) : super(key: key);

  @override
  State<Editbutton1> createState() => _Editbutton1State();
}

class _Editbutton1State extends State<Editbutton1> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  "     Player 1 Score :",
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/subtract.png'),
                    onPressed: () {
                      setState(() {
                        if (update_score_1_first > 0) {
                          update_score_1_first--;
                        }
                        super.deactivate();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Text(
                    " $update_score_1_first",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/add.png'),
                    onPressed: () {
                      setState(() {
                        update_score_1_first++;
                        super.deactivate();
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10),
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  "     Player 2 Score :",
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/subtract.png'),
                    onPressed: () {
                      setState(() {
                        if (update_score_1_second > 0) {
                          update_score_1_second--;
                        }
                        super.deactivate();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Text(
                    " $update_score_1_second",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/add.png'),
                    onPressed: () {
                      setState(() {
                        update_score_1_second++;
                        super.deactivate();
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: TextButton(
                    onPressed: () {
                      // score_1_first = update_score_1_first;
                      // score_1_second = update_score_1_second;
                      final Score = Score_LiveMaintainer(
                          PLAYER_1_SCORE: update_score_1_first.toString(),
                          PLAYER_2_SCORE: update_score_1_second.toString(),
                          set: "1");
                      final scoremap = Score.toMap();
                      final json_score = jsonEncode(scoremap);
                      socket.emit('update-score', json_score);
                      socket.on('score-updated', (data) {
                        print('1');
                        print(data.toString());
                      });
                      super.deactivate();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveMaintainer(
                            Tournament_ID: widget.Tournament_Id,
                            Match_Id: widget.Match_Id,
                            Player_1_name: widget.Player_1_name,
                            Player1_Partner: widget.Player1_Partner,
                            Player_2_name: widget.Player_2_name,
                            Player2_Partner: widget.Player2_Partner,
                            Player1_ID: "",
                            Player2_ID: "",
                            player1_set_1: update_score_1_first,
                            player1_set_2: widget.player1_set_2,
                            player1_set_3: widget.player1_set_3,
                            player2_set_1: update_score_1_second,
                            player2_set_2: widget.player2_set_2,
                            player2_set_3: widget.player2_set_3,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Editbutton2 extends StatefulWidget {
  final String Tournament_ID;
  final String Match_Id;
  final String Player_1_name;
  final String Player_2_name;
  final String Player1_Partner;
  final String Player2_Partner;
  final int player1_set_1;
  final int player1_set_2;
  final int player1_set_3;
  final int player2_set_1;
  final int player2_set_2;
  final int player2_set_3;
  const Editbutton2({
    Key? key,
    required this.Tournament_ID,
    required this.Match_Id,
    required this.Player_1_name,
    required this.Player_2_name,
    required this.Player1_Partner,
    required this.Player2_Partner,
    required this.player1_set_1,
    required this.player1_set_2,
    required this.player1_set_3,
    required this.player2_set_1,
    required this.player2_set_2,
    required this.player2_set_3,
  }) : super(key: key);

  @override
  State<Editbutton2> createState() => _Editbutton2State();
}

class _Editbutton2State extends State<Editbutton2> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 5,
            ),
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  "     Player 1 Score :",
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/subtract.png'),
                    onPressed: () {
                      setState(() {
                        if (update_score_2_first > 0) {
                          update_score_2_first--;
                        }
                        super.deactivate();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Text(
                    " $update_score_2_first",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/add.png'),
                    onPressed: () {
                      setState(() {
                        update_score_2_first++;
                        super.deactivate();
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10),
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  "     Player 2 Score :",
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/subtract.png'),
                    onPressed: () {
                      setState(() {
                        if (update_score_2_second > 0) {
                          update_score_2_second--;
                        }
                        super.deactivate();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Text(
                    " $update_score_2_second",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/add.png'),
                    onPressed: () {
                      setState(() {
                        setState(() {
                          update_score_2_second++;
                          super.deactivate();
                        });
                        super.deactivate();
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        // score_2_first = update_score_2_first;
                        // score_2_second = update_score_2_second;
                        super.deactivate();
                      });
                      final Score = Score_LiveMaintainer(
                          PLAYER_1_SCORE: update_score_2_first.toString(),
                          PLAYER_2_SCORE: update_score_2_second.toString(),
                          set: "2");
                      final scoremap = Score.toMap();
                      final json_score = jsonEncode(scoremap);
                      socket.emit('update-score', json_score);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveMaintainer(
                            Tournament_ID: widget.Tournament_ID,
                            Match_Id: widget.Match_Id,
                            Player_1_name: widget.Player_1_name,
                            Player1_Partner: widget.Player1_Partner,
                            Player_2_name: widget.Player_2_name,
                            Player2_Partner: widget.Player2_Partner,
                            Player1_ID: "",
                            Player2_ID: "",
                            player1_set_1: widget.player1_set_1,
                            player1_set_2: update_score_2_first,
                            player1_set_3: widget.player1_set_3,
                            player2_set_1: widget.player2_set_1,
                            player2_set_2: update_score_2_second,
                            player2_set_3: widget.player2_set_3,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Editbutton3 extends StatefulWidget {
  final String Tournament_ID;
  final String Match_Id;
  final String Player_1_name;
  final String Player_2_name;
  final String Player1_Partner;
  final String Player2_Partner;
  final int player1_set_1;
  final int player1_set_2;
  final int player1_set_3;
  final int player2_set_1;
  final int player2_set_2;
  final int player2_set_3;
  const Editbutton3({
    Key? key,
    required this.Tournament_ID,
    required this.Match_Id,
    required this.Player_1_name,
    required this.Player_2_name,
    required this.Player1_Partner,
    required this.Player2_Partner,
    required this.player1_set_1,
    required this.player1_set_2,
    required this.player1_set_3,
    required this.player2_set_1,
    required this.player2_set_2,
    required this.player2_set_3,
  }) : super(key: key);
  @override
  State<Editbutton3> createState() => _Editbutton3State();
}

class _Editbutton3State extends State<Editbutton3> {
  @override
  var update_score = 0;
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 5,
            ),
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  "     Player 1 Score :",
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/subtract.png'),
                    onPressed: () {
                      setState(() {
                        if (update_score_3_first > 0) {
                          update_score_3_first--;
                        }
                        super.deactivate();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Text(
                    " $update_score_3_first",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/add.png'),
                    onPressed: () {
                      setState(() {
                        update_score_3_first++;
                        super.deactivate();
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10),
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  "     Player 2 Score :",
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/subtract.png'),
                    onPressed: () {
                      setState(() {
                        if (update_score_3_second > 0) {
                          update_score_3_second--;
                        }
                        super.deactivate();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Text(
                    " $update_score_3_second",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/add.png'),
                    onPressed: () {
                      setState(() {
                        update_score_3_second++;
                        super.deactivate();
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      // score_3_first = update_score_3_first;
                      // score_3_second = update_score_3_second;
                      final Score = Score_LiveMaintainer(
                          PLAYER_1_SCORE: update_score_3_first.toString(),
                          PLAYER_2_SCORE: update_score_3_second.toString(),
                          set: "3");
                      final scoremap = Score.toMap();
                      final json_score = jsonEncode(scoremap);
                      socket.emit('update-score', json_score);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveMaintainer(
                            Tournament_ID: widget.Tournament_ID,
                            Match_Id: widget.Match_Id,
                            Player_1_name: widget.Player_1_name,
                            Player1_Partner: widget.Player1_Partner,
                            Player_2_name: widget.Player_2_name,
                            Player2_Partner: widget.Player2_Partner,
                            Player1_ID: "",
                            Player2_ID: "",
                            player1_set_1: widget.player1_set_1,
                            player1_set_2: widget.player1_set_2,
                            player1_set_3: update_score_3_first,
                            player2_set_1: widget.player2_set_1,
                            player2_set_2: widget.player2_set_2,
                            player2_set_3: update_score_3_second,
                          ),
                        ),
                      ); // Timer.periodic(const Duration(seconds: 2), (timer) {});

                      super.deactivate();
                    });
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Submit extends StatefulWidget {
  final String MatchId;
  final String Tournament_ID;
  final String p1_name;
  final String p1_partner_name;
  final String p2_name;
  final String p2_partner_name;
  final int player1_set_1;
  final int player1_set_2;
  final int player1_set_3;
  final int player2_set_1;
  final int player2_set_2;
  final int player2_set_3;
  const Submit({
    Key? key,
    required this.Tournament_ID,
    required this.MatchId,
    required this.p1_name,
    required this.p1_partner_name,
    required this.p2_name,
    required this.p2_partner_name,
    required this.player1_set_1,
    required this.player1_set_2,
    required this.player1_set_3,
    required this.player2_set_1,
    required this.player2_set_2,
    required this.player2_set_3,
  }) : super(key: key);

  @override
  State<Submit> createState() => _SubmitState();
}

class _SubmitState extends State<Submit> {
  final controller = ConfettiController(duration: const Duration(seconds: 3));
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    controller.addListener(() => setState(() {
          isPlaying = controller.state == ConfettiControllerState.playing;
        }));
  }

  @override
  Map? UserResponse;

  String? x;
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Back Alert"),
            content: const Text("Are you sure you want to go to back?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  child: const Text(
                    "NO",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(LiveMaintainerMatchSelection(
                    Tournament_id: widget.Tournament_ID,
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  child:
                      const Text("YES", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
        return false;
      },
      child: WillPopScope(
        onWillPop: () {
          Get.to(HomePage());

          return Future.value(false);
        },
        child: Scaffold(
          body: SafeArea(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/Homepage.png"),
                        fit: BoxFit.cover)),
                child: SafeArea(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          height: 447,
                          width: 400,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            color: Colors.white.withOpacity(0.2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  child: Center(
                                    child: Text(
                                      "${UserResponse == null ? "Press Confirm to know the winner" : UserResponse?['WINNER']}",
                                      style: TextStyle(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 329,
                                  height: 279,
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    color: Color(0xff252626),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 7,
                                        ),
                                        SizedBox(
                                          width: 125,
                                          height: 240,
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: 112,
                                                  height: 60,
                                                  child: Card(
                                                    elevation: 5,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                    color: Color(0xff252626),
                                                    child: Center(
                                                      child: Text(
                                                          "${widget.p1_name}\n${widget.p1_partner_name}"),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                Center(
                                                  child: Text(
                                                    "${widget.player1_set_1}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 25.0,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Center(
                                                  child: Text(
                                                    "${widget.player1_set_2}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 25.0,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Center(
                                                  child: Text(
                                                    "${widget.player1_set_3}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 25.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 17,
                                        ),
                                        SizedBox(
                                          width: 125,
                                          height: 240,
                                          child: ConfettiWidget(
                                            confettiController: controller,
                                            shouldLoop: false,
                                            blastDirection: -3.14 / 2,
                                            blastDirectionality:
                                                BlastDirectionality.explosive,
                                            numberOfParticles: 40,
                                            gravity: 0.1,
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width: 112,
                                                    height: 60,
                                                    child: Card(
                                                      elevation: 5,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                      color: Color(0xff252626),
                                                      child: Center(
                                                        child: Text(
                                                            "${widget.p2_name}\n${widget.p2_partner_name}"),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 16,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      "${widget.player2_set_1}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 25.0,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      "${widget.player2_set_2}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 25.0,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      "${widget.player2_set_3}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 25.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 350,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xffD15858),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (isPlaying) {
                                            controller.stop();
                                          } else {
                                            controller.play();
                                          }

                                          var url =
                                              "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/endMatch?TOURNAMENT_ID=${widget.Tournament_ID}&MATCHID=Match-${widget.MatchId}";

                                          http.Response response;
                                          response = await get(Uri.parse(url));
                                          setState(() {
                                            UserResponse =
                                                json.decode(response.body);
                                          });
                                          print(
                                              'MATCH WINNER ${UserResponse?['WINNER']}');
                                        },
                                        child: const Text(
                                          "Confirm",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "Press back to exit!",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
