import 'dart:convert';
import 'package:ardent_sports/ticket.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

bool showAdd = false;
bool showPlayers = false;
String? email = "";
var players = [];
var subs = [];
String? teamName = "Add";

class CricketTeamDetails extends StatefulWidget {
  final String id;
  final String TOURNAMENT_ID;
  final int TEAM_SIZE;
  final int SUBSTITUTE;
  final int OVERS;
  final String BALL_TYPE;
  CricketTeamDetails({
    Key? key,
    required this.id,
    required this.TOURNAMENT_ID,
    required this.TEAM_SIZE,
    required this.SUBSTITUTE,
    required this.OVERS,
    required this.BALL_TYPE,
  }) : super(key: key);

  @override
  State<CricketTeamDetails> createState() => _CricketTeamDetails();
}

void finalTeam(context) {
  showDialog(
      context: context,
      builder: (_) => SimpleDialog(
              contentPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
              title: const Text("Team Number"),
              children: [
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      Container(
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text("Name",
                                        style: TextStyle(fontSize: 20)))),
                            SizedBox(height: 10),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text("Category",
                                        style: TextStyle(fontSize: 20)))),
                            SizedBox(height: 10),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text("Event",
                                        style: TextStyle(fontSize: 20)))),
                            SizedBox(height: 10),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text("Date",
                                        style: TextStyle(fontSize: 20)))),
                            SizedBox(height: 10),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text("Address",
                                        style: TextStyle(fontSize: 20)))),
                            SizedBox(height: 10),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text("City",
                                        style: TextStyle(fontSize: 20)))),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 30,
                          width: 160,
                          child: TextButton(
                              onPressed: () {},
                              child: Text("OK"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 234, 16, 23)),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )))))
                    ]))
              ]));
}

void addInput(context, tournamentId, email) {
  TextEditingController addteam = TextEditingController();
  showDialog(
      context: context,
      builder: (_) => SimpleDialog(
              contentPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
              title: const Text("Enter Team Name"),
              children: <Widget>[
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: [
                        TextField(
                          controller: addteam,
                          decoration: InputDecoration(
                            labelText: 'Enter Team name',
                            hintText: "Enter Team name",
                            prefixIcon: Icon(Icons.star),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              gapPadding: 0.0,
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              var sendData = jsonEncode({
                                "TOURNAMENT_ID": tournamentId,
                                "CAPTAIN": email,
                                "NAME": addteam.text,
                              });
                              setState(() {
                                teamName = addteam.text;
                              });
                              print(sendData);

                              var url =
                                  "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/cricketTeamName";
                              var response = await post(Uri.parse(url),
                                  body: sendData,
                                  headers: {
                                    "Content-Type": "application/json"
                                  });
                              print(response.body);
                            },
                            child: const Text("Submit"))
                      ]),
                    );
                  },
                )
              ]));
}

printdatalist(dynamic data, dynamic details) {
  data.forEach((key, value) {
    print('$key: $value');
  });

  for (var data in details) {
    data.forEach((key, value) {
      print('$key: $value');
    });
  }
}

Future<String?> getEmailFromSharedPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  return email;
}

class _CricketTeamDetails extends State<CricketTeamDetails> {
  Widget playerAdd(context, deviceWidth, i, tournamentId) {
    return (Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                textStyle: MaterialStateProperty.all(const TextStyle(
                  color: Colors.black,
                )),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
            child: Text("Add player " + (i + 1).toString() + " >",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            onPressed: () {
              addPlayer(context, i, tournamentId);
            })));
  }

  Widget SubsplayerAdd(context, deviceWidth, i, tournamentId) {
    return (Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
              textStyle: MaterialStateProperty.all(TextStyle(
                color: Colors.black,
              )),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ))),
          child: Text("Add Substitute " + (i + 1).toString() + " >",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () {
            addSubs(context, i, tournamentId);
          }),
    ));
  }

  void addPlayer(context, i, tournamentId) {
    TextEditingController addplayer = TextEditingController();
    TextEditingController searchplayer = TextEditingController();
    var playerDetails = {};
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              contentPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
              title: Text("Add Player " + (i + 1).toString()),
              children: <Widget>[
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      TextField(
                        controller: searchplayer,
                        decoration: InputDecoration(
                          labelText: 'Search Player name',
                          hintText: "Search Player name",
                          prefixIcon: Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            gapPadding: 0.0,
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.5),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                          onPressed: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var captain = prefs.getString('email');
                            // Navigator.pop(context);
                            //API CALL
                            var searchPlayer = {
                              "TOURNAMENT_ID": tournamentId,
                              "player": searchplayer.text,
                              "CAPTAIN": captain
                            };
                            var sendPlayer = jsonEncode(searchPlayer);
                            var url =
                                "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/validatePlayerCricket";

                            //JSON
                            var response2 = await post(Uri.parse(url),
                                body: sendPlayer,
                                headers: {"Content-Type": "application/json"});
                            var details = jsonDecode(response2.body);
                            print("😂" + response2.body);
                            print("😂😂" + details["Message"]);
                            Fluttertoast.showToast(
                                msg: details["Message"],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            playerDetails = details;
                            playerDetails["CAPTAIN"] = captain;
                            if (details["Message"] == "Can Add Player") {
                              print("Show Add");
                              setState(() {
                                showAdd = true;
                              });
                            } else {
                              print("Nothing to see");
                            }
                          },
                          child: const Text("Search"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 76, 175, 86)),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )))),
                      SizedBox(height: 10),
                      // if (playerDetails["Message"] == "Can Add Player"){
                      // Text(
                      //   playerDetails["NAME"],
                      //   style: TextStyle(color: Colors.black, fontSize: 20),
                      // ),
                      SizedBox(height: 10),
                      (showAdd)
                          ? TextButton(
                              onPressed: () {
                                if (playerDetails["Message"] ==
                                    "Player not found") {
                                  print("Player not found");
                                }
                                var addURL =
                                    "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/addTeamPlayers";
                                var playerJSON = {
                                  "TOURNAMENT_ID": tournamentId,
                                  "player": {
                                    "USERID": playerDetails["USERID"],
                                    "NAME": playerDetails["NAME"],
                                  },
                                  "CAPTAIN": email,
                                };

                                var sendAddReq = jsonEncode(playerJSON);

                                var response3 = post(Uri.parse(addURL),
                                    body: sendAddReq,
                                    headers: {
                                      "Content-Type": "application/json"
                                    });
                                setState(() {
                                  players.add({
                                    "USERID": playerDetails["USERID"],
                                    "NAME": playerDetails["NAME"],
                                  });
                                });
                                Fluttertoast.showToast(
                                    msg: "Successfully Added Player",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Color.fromARGB(255, 33, 237, 6),
                                    fontSize: 16.0);

                                // Set state to false
                                setState(() {
                                  showAdd = false;
                                });

                                // Reload the page
                                Navigator.pop(_);
                              },
                              child: const Text("Add"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 234, 16, 23)),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))))
                          : Text("")
                    ]),
                  );
                })
              ],
            ));
  }

  void addSubs(context, i, tournamentId) {
    TextEditingController addsubstitute = TextEditingController();
    TextEditingController searchplayer = TextEditingController();
    var playerDetails = {};
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              contentPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
              title: Text("Add Substitute " + (i + 1).toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  )),
              children: <Widget>[
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      TextField(
                        controller: searchplayer,
                        decoration: InputDecoration(
                          labelText: 'Search Player name',
                          hintText: "Search Player name",
                          prefixIcon: Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            gapPadding: 0.0,
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.5),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                          onPressed: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var captain = prefs.getString('email');
                            // Navigator.pop(context);
                            //API CALL
                            var searchPlayer = {
                              "TOURNAMENT_ID": tournamentId,
                              "player": searchplayer.text,
                              "CAPTAIN": captain
                            };
                            var sendPlayer = jsonEncode(searchPlayer);
                            var url =
                                "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/validatePlayerCricket";

                            //JSON
                            var response2 = await post(Uri.parse(url),
                                body: sendPlayer,
                                headers: {"Content-Type": "application/json"});
                            var details = jsonDecode(response2.body);
                            print("😂" + response2.body);
                            print("😂😂" + details["Message"]);
                            Fluttertoast.showToast(
                                msg: details["Message"],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            playerDetails = details;
                            playerDetails["CAPTAIN"] = captain;
                            print("😂😂yoo😂" + details["Message"]);
                            if (details["Message"] == "Can Add Player") {
                              setState(() {
                                showAdd = true;
                              });
                              print("Show Add");
                            } else {
                              print("Nothing to see");
                            }
                          },
                          child: const Text("Search"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 76, 175, 86)),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )))),
                      SizedBox(height: 10),
                      // Text(
                      //   playerDetails["NAME"],
                      //   style: TextStyle(color: Colors.black, fontSize: 20),
                      // ),
                      SizedBox(height: 10),
                      (showAdd)
                          ? TextButton(
                              onPressed: () {
                                // In this place, we should use the response2 from line 130

                                var addURL =
                                    "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/addSubstitutePlayers";
                                var playerJSON = {
                                  "TOURNAMENT_ID": tournamentId,
                                  "substitute": {
                                    "USERID": playerDetails["USERID"],
                                    "NAME": playerDetails["NAME"],
                                  },
                                  "CAPTAIN": email,
                                };

                                var sendAddReq = jsonEncode(playerJSON);

                                var response3 = post(Uri.parse(addURL),
                                    body: sendAddReq,
                                    headers: {
                                      "Content-Type": "application/json"
                                    });
                                setState(() {
                                  subs.add({
                                    "USERID": playerDetails["USERID"],
                                    "NAME": playerDetails["NAME"],
                                  });
                                });
                                Fluttertoast.showToast(
                                    msg: "Successfully Added Player",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Color.fromARGB(255, 33, 237, 6),
                                    fontSize: 16.0);

                                // set state to false
                                setState(() {
                                  showAdd = false;
                                });

                                // Reload the page
                                Navigator.pop(_);
                              },
                              child: const Text("Add"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 234, 16, 23)),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))))
                          : Text(""),
                    ]),
                  );
                })
              ],
            ));
  }

  void DetailsOfPlayer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? e = prefs.getString('email');
    var url =
        "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/getPlayers?TOURNAMENT_ID=${widget.TOURNAMENT_ID}&CAPTAIN=${e}";
    print("😂" + url);
    var response = await get(Uri.parse(url));
    print("All Players");
    print(response.body);

    var allData = jsonDecode(response.body);

    setState(() {
      teamName = allData['TEAM_NAME'];
      players = allData['PLAYERS'];
      subs = allData["SUBSTITUTE"];
    });
  }

  @override
  void initState() {
    super.initState();
    getEmailFromSharedPrefs().then((value) {
      setState(() {
        email = value;
      });
    });
    DetailsOfPlayer();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/Homepage.png"),
                      fit: BoxFit.cover),
                ),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Image(
                                  image: AssetImage("assets/back_edit.png"),
                                )),
                          ]),
                      Card(
                        elevation: 10,
                        color: Colors.white.withOpacity(0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                                child: SingleChildScrollView(
                                    child: Column(
                              children: <Widget>[
                                SizedBox(height: 30),
                                (teamName == "Add" || teamName == "")
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextButton(
                                            style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        0),
                                                padding:
                                                    MaterialStateProperty.all(
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 20,
                                                            vertical: 20)),
                                                textStyle:
                                                    MaterialStateProperty.all(
                                                        const TextStyle(
                                                  color: Colors.black,
                                                )),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ))),
                                            child: const Text(
                                                "Add Team Name   >>"),
                                            onPressed: () {
                                              print("😀");
                                              addInput(context,
                                                  widget.TOURNAMENT_ID, email);
                                            }))
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 10),
                                            child: Text(
                                                teamName ?? "Not fetched yet",
                                                style: TextStyle(
                                                  fontSize: 30,
                                                )))),
                                const SizedBox(height: 10),
                                for (int i = 0; i < players.length; i++)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          style: ButtonStyle(
                                              elevation:
                                                  MaterialStateProperty.all(0),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 20)),
                                              textStyle:
                                                  MaterialStateProperty.all(
                                                      const TextStyle(
                                                color: Colors.black,
                                              )),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ))),
                                          child: Text(players[i]["NAME"],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18)),
                                          onPressed: () {}),
                                      (i != 0)
                                          ? IconButton(
                                              onPressed: () async {
                                                var url =
                                                    "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/removePlayer";
                                                print("😂" + url);
                                                var sendData = jsonEncode({
                                                  "TOURNAMENT_ID":
                                                      widget.TOURNAMENT_ID,
                                                  "CAPTAIN": email,
                                                  "NAME": players[i]["NAME"]
                                                });
                                                var response = await post(
                                                    Uri.parse(url),
                                                    body: sendData,
                                                    headers: {
                                                      "Content-Type":
                                                          "application/json"
                                                    });
                                                print("All Players");
                                                // print(response.body);

                                                // Reload the page
                                                setState(() {
                                                  print("👍🏻");
                                                  print(players);
                                                  players.removeAt(i);
                                                });
                                              },
                                              icon: const Icon(
                                                  Icons.delete_forever_rounded),
                                              color: Colors.red)
                                          : const Text("")
                                    ],
                                  ),
                                for (int i = players.length;
                                    i < widget.TEAM_SIZE;
                                    i++)
                                  Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: playerAdd(context, deviceWidth, i,
                                          widget.TOURNAMENT_ID)),
                                const SizedBox(height: 15),
                                for (int i = 0; i < subs.length; i++)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          style: ButtonStyle(
                                              elevation:
                                                  MaterialStateProperty.all(0),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 20)),
                                              textStyle:
                                                  MaterialStateProperty.all(
                                                      const TextStyle(
                                                color: Colors.black,
                                              )),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ))),
                                          child: Text(subs[i]["NAME"],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              )),
                                          onPressed: () {}),
                                      IconButton(
                                          onPressed: () async {
                                            var url =
                                                "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/removeSubstitue";
                                            print("😂" + url);
                                            var sendData = jsonEncode({
                                              "TOURNAMENT_ID":
                                                  widget.TOURNAMENT_ID,
                                              "CAPTAIN": email,
                                              "NAME": subs[i]["NAME"]
                                            });
                                            setState(() {
                                              subs.removeAt(i);
                                            });
                                            var response = await post(
                                                Uri.parse(url),
                                                body: sendData,
                                                headers: {
                                                  "Content-Type":
                                                      "application/json"
                                                });

                                            // Reload the page
                                          },
                                          icon: const Icon(
                                              Icons.delete_forever_rounded),
                                          color: Colors.red)
                                    ],
                                  ),
                                for (int i = subs.length;
                                    i < widget.SUBSTITUTE;
                                    i++)
                                  Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SubsplayerAdd(context, deviceWidth,
                                          i, widget.TOURNAMENT_ID)),
                                const SizedBox(height: 10),
                                // SizedBox(
                                //     height: 30,
                                //     width: 150,
                                //     child: TextButton(
                                //       onPressed: () {
                                //         finalTeam(context);
                                //       },
                                //       child: const Text(
                                //         "Submit",
                                //       ),
                                //       style: ButtonStyle(
                                //           backgroundColor:
                                //               MaterialStateProperty.all(
                                //                   const Color.fromARGB(
                                //                       255, 226, 64, 64)),
                                //           foregroundColor:
                                //               MaterialStateProperty.all(
                                //                   Colors.white),
                                //           shape: MaterialStateProperty.all<
                                //                   RoundedRectangleBorder>(
                                //               RoundedRectangleBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(10.0),
                                //           ))),
                                //     )),
                                const SizedBox(height: 20),
                              ],
                            ))),
                          ],
                        ),
                      )
                    ])))));
  }
}
