import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'Helper/apis.dart';
import 'Helper/constant.dart';
import 'LiveMaintainerMatchSelection.dart';
import 'features/home_page/home_page.dart';
import 'features/menu/Menu.dart';
import 'features/cricket_module/cricket_team_details_input.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ScoreAChallenge extends StatefulWidget {
  final String? name;
  const ScoreAChallenge({Key? key, required this.name}) : super(key: key);

  @override
  State<ScoreAChallenge> createState() => _ScoreAChallengeState();
}

class TournamentIdCheck {
  late String TOURNAMENT_ID;
  late String SPORT;

  TournamentIdCheck({required this.TOURNAMENT_ID, required this.SPORT});
  Map<String, dynamic> toMap() {
    return {"TOURNAMENT_ID": TOURNAMENT_ID, "SPORT": SPORT};
  }
}

class _ScoreAChallengeState extends State<ScoreAChallenge> {
  Future<void> _refreshScore() async {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (a, b, c) => ScoreAChallenge(
                  name: widget.name,
                )));
  }

  @override
  String sport_name = "Select a sport";
  bool isLoading = false;
  TextEditingController challengeid = TextEditingController();
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Homepage.png"), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                              pageBuilder: (a, b, c) => const HomePage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 90,
                          height: 50,
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
                        width: 130,
                        height: 40,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/Ardent_Sport_Text.png"),
                                fit: BoxFit.fitWidth)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Menu(
                                        name: widget.name,
                                      )));
                        },
                        child: Container(
                          width: 20,
                          height: 16,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/menu_bar.png"),
                                  fit: BoxFit.fitHeight)),
                        ),
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
                        width: 40,
                        height: 40,
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
                        margin: const EdgeInsets.only(left: 30),
                        child: Text("${widget.name}"),
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
                  margin: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    color: Colors.white.withOpacity(0.2),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        const Center(
                          child: Text(
                            'Score a challenge',
                            style: TextStyle(
                                color: Color(0xffE74545), fontSize: 20),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).size.height / 1.08,
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Card(
                            elevation: 10,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                sport_name,
                                style:
                                    const TextStyle(color: Color(0xffE74545)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      sport_name = "Badminton";
                                    });
                                  },
                                  child: const Text(
                                    "Badminton",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      sport_name = "Table Tennis";
                                    });
                                  },
                                  child: const Text(
                                    "Table Tennis",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      sport_name = "Cricket";
                                    });
                                  },
                                  child: const Text(
                                    "Cricket",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: double.infinity,
                          ),
                        ),
                        const Text(
                          "Enter Challenge Id :",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.04),
                            ),
                            child: TextField(
                              controller: challengeid,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceWidth * 0.04),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceWidth * 0.04),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Enter Challenge ID :",
                                  hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceWidth * 0.02),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: deviceWidth * 0.1,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width - 50,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffE74545),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () async {
                                if (sport_name == "Badminton" ||
                                    sport_name == "Table Tennis") {
                                  if (challengeid.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text("Please Enter the challenge ID"),
                                    ));
                                  } else {
                                    final TournamentIdCheckdata =
                                        TournamentIdCheck(
                                            TOURNAMENT_ID: challengeid.text,
                                            SPORT: sport_name);
                                    final TournamentIdCheckMap =
                                        TournamentIdCheckdata.toMap();
                                    final json =
                                        jsonEncode(TournamentIdCheckMap);

                                    try {
                                      EasyLoading.show(
                                          status: 'Loading...',
                                          maskType: EasyLoadingMaskType.black);
                                      var response = await post(
                                          tourneyExistsApi,
                                          headers: {
                                            "Accept": "application/json",
                                            "Content-Type": "application/json"
                                          },
                                          body: json,
                                          encoding:
                                              Encoding.getByName("utf-8"));
                                      Map<String, dynamic> jsonData =
                                          jsonDecode(response.body);
                                      if (jsonData["Message"] == "Success") {
                                        EasyLoading.dismiss();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LiveMaintainerMatchSelection(
                                                      Tournament_id:
                                                          challengeid.text,
                                                    )));
                                      } else {
                                        EasyLoading.dismiss();
                                        EasyLoading.showError(
                                            "Invalid Challenge ID or sport selected");
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                } else if (sport_name == "Cricket") {
                                  // api call
                                  var tournamentIdObj = {
                                    "TOURNAMENT_ID": challengeid.text
                                  };
                                  var sendTournamentIdObj =
                                      jsonEncode(tournamentIdObj);
                                  print(
                                      "👌 Object is : $tournamentIdObj and the json sent is $sendTournamentIdObj");
                                  var url =
                                      "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/startScoringFlow";
                                  var response = await post(Uri.parse(url),
                                      body: sendTournamentIdObj,
                                      headers: {
                                        "Content-Type": "application/json"
                                      });
                                  print("👌👌👌👌 Response : ${response.body}");
                                  if(jsonDecode(response.body)["message"] == "All Matches Completed"){
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        content: Text(jsonDecode(response.body)["message"])));
                                  } else if(jsonDecode(response.body)["message"] == "Not All teams are full "){
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        content: Text(jsonDecode(response.body)["message"])));
                                  }
                                  else{

                                    var allTeams = jsonDecode(response.body)["team"];
                                    print(allTeams);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CricketTeamDetasilsInput(
                                                  tournamentId: challengeid.text,
                                                  allMatches : allTeams
                                                )));
                                  }

                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Please Select a sport"),
                                  ));
                                }
                              },
                              child: const Text("Submit"),
                            ),
                          ),
                        )
                      ],
                    ),
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
