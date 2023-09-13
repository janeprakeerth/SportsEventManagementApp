import 'dart:convert';
import 'package:ardent_sports/features/live_maintainer_badminton/live_maintainer_badminton.dart';
import 'package:ardent_sports/LiveMaintainerTableTennis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'Helper/constant.dart';
import 'features/home_page/home_page.dart';
import 'features/web_view/web_view_live_maintainer_preview_fixture.dart';

class LiveMaintainerMatchSelection extends StatefulWidget {
  final String Tournament_id;
  const LiveMaintainerMatchSelection({Key? key, required this.Tournament_id})
      : super(key: key);

  @override
  State<LiveMaintainerMatchSelection> createState() =>
      _LiveMaintainerMatchSelectionState();
}

class MatchesData {
  late String TOURNAMENT_ID;
  late String PLAYER1_NAME;
  late String PLAYER1_PARTNER;
  late String PLAYER2_NAME;
  late String PLAYER2_PARTNER;
  late String PLAYER1_ID;
  late String PLAYER2_ID;
  late String MATCHID;
  late String SPORT_NAME;
  late String LOCATION;
  late String CITY;
  late String TOURNAMENT_NAME;
  late String IMG_URL;
  late String PRIZE_POOL;

  MatchesData(
    this.TOURNAMENT_ID,
    this.PLAYER1_NAME,
    this.PLAYER1_PARTNER,
    this.PLAYER2_NAME,
    this.PLAYER2_PARTNER,
    this.PLAYER1_ID,
    this.PLAYER2_ID,
    this.MATCHID,
    this.SPORT_NAME,
    this.LOCATION,
    this.CITY,
    this.TOURNAMENT_NAME,
    this.IMG_URL,
    this.PRIZE_POOL,
  );

  MatchesData.fromJson(Map<String, dynamic> json) {
    TOURNAMENT_ID = json['TOURNAMENT_ID'];
    PLAYER1_NAME = json['PLAYER1_NAME'];
    PLAYER1_PARTNER = json['PLAYER1_PARTNER'];
    PLAYER2_NAME = json['PLAYER2_NAME'];
    PLAYER2_PARTNER = json['PLAYER2_PARTNER'];
    PLAYER1_ID = json['PLAYER1_ID'];
    PLAYER2_ID = json['PLAYER2_ID'];
    MATCHID = json['MATCHID'];
    SPORT_NAME = json['SPORT_NAME'];
    LOCATION = json['LOCATION'];
    CITY = json['CITY'];
    TOURNAMENT_NAME = json['TOURNAMENT_NAME'];
    IMG_URL = json['IMG_URL'];
    PRIZE_POOL = json['PRIZE_POOL'];
  }
}

class _LiveMaintainerMatchSelectionState
    extends State<LiveMaintainerMatchSelection> {
  var futures;
  List<Container> AllUpcomingHostedMatches = [];

  List<Card> AllMatches = [];

  List<Card> getHostedMatches(List<MatchesData> matchesdata, int arrayLength) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    if (arrayLength == 0) {
      var container = Card(
        margin: EdgeInsets.fromLTRB(deviceWidth * 0.03, 0, 0, 0),
        child: const Text("There arent any matches in this Tournament"),
      );
      AllMatches.add(container);
    } else {
      for (int i = 0; i < arrayLength; i++) {
        var container = Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(deviceWidth * 0.03),
          ),
          elevation: 10,
          color: Colors.white60.withOpacity(0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: Container(
                margin: EdgeInsets.only(top: deviceWidth * 0.002),
                height: MediaQuery.of(context).size.height * 0.075,
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => BadmintonSpotSelection(
                    //           tourneyId: matchesdata[i].TOURNAMENT_ID,
                    //         )));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                    ),
                    elevation: 20,
                    color: matchesdata[i].SPORT_NAME == 'Badminton'
                        ? const Color(0xff6BB8FF)
                        : const Color(0xff03C289),
                    child: Row(
                      children: [
                        SizedBox(
                          width: deviceWidth * 0.03,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: deviceWidth * 0.1,
                          width: deviceWidth * 0.1,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent.withOpacity(0.6),
                              backgroundBlendMode: BlendMode.darken),
                          child: Image(
                            image: NetworkImage(matchesdata[i].IMG_URL),
                            height: deviceWidth * 0.04,
                            width: deviceWidth * 0.04,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: deviceWidth * 0.04,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              matchesdata[i].TOURNAMENT_NAME.length > 25
                                  ? matchesdata[i]
                                          .TOURNAMENT_NAME
                                          .substring(0, 25) +
                                      '...'
                                  : matchesdata[i].TOURNAMENT_NAME,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: deviceWidth * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: deviceWidth * 0.01,
                            ),
                            Text(
                              matchesdata[i].CITY,
                              style: TextStyle(
                                fontSize: deviceWidth * 0.035,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
              SizedBox(
                height: deviceWidth * 0.018,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceWidth * 0.018),
                ),
                elevation: 1,
                color: Colors.transparent.withOpacity(0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                left: deviceWidth * 0.08,
                                top: deviceWidth * 0.02),
                            child: Text(
                              matchesdata[i].PLAYER1_NAME,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                            margin: EdgeInsets.only(
                                left: deviceWidth * 0.08,
                                top: deviceWidth * 0.02,
                                bottom: deviceWidth * 0.02),
                            child: Text(
                              matchesdata[i].PLAYER1_PARTNER,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Vs",
                          style: TextStyle(
                            fontSize: deviceWidth * 0.04,
                            color: const Color(0xffE74545),
                          ),
                        )),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              right: deviceWidth * 0.07,
                              top: deviceWidth * 0.02),
                          child: Text(
                            matchesdata[i].PLAYER2_NAME,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              right: deviceWidth * 0.07,
                              top: deviceWidth * 0.02,
                              bottom: deviceWidth * 0.02),
                          child: Text(
                            matchesdata[i].PLAYER2_PARTNER,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                  ),
                  elevation: 1,
                  color: Colors.transparent.withOpacity(0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: deviceWidth * 0.07),
                          child: Row(
                            children: [
                              Image(
                                image: const AssetImage("assets/trophy 2.png"),
                                height: deviceWidth * 0.05,
                              ),
                              SizedBox(
                                width: deviceWidth * 0.03,
                              ),
                              const Text(
                                "Prize money",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(right: deviceWidth * 0.07),
                          child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      fontSize: deviceWidth * 0.027,
                                      color: Colors.white),
                                  children: <TextSpan>[
                                const TextSpan(text: "Up to "),
                                TextSpan(
                                    text: " ₹",
                                    style: TextStyle(
                                      fontSize: deviceWidth * 0.05,
                                    )),
                                TextSpan(
                                  text: matchesdata[i].PRIZE_POOL.toString(),
                                  style: TextStyle(
                                      fontSize: deviceWidth * 0.05,
                                      color: const Color(0xffE74545),
                                      fontWeight: FontWeight.bold),
                                ),
                              ])))
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(deviceWidth * 0.02),
                    child: const Image(
                      image: AssetImage("assets/Location.png"),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      matchesdata[i].LOCATION,
                      style: TextStyle(
                          color: Colors.white, fontSize: deviceWidth * 0.03),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.055,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: const Color(0xffE74545),
                      borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        var url =
                            "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/startscoring?TOURNAMENT_ID=${matchesdata[i].TOURNAMENT_ID}&MATCHID=${matchesdata[i].MATCHID}";
                        var response = await get(Uri.parse(url));
                        Map? mapUserInfo;
                        mapUserInfo = json.decode(response.body);
                        if (matchesdata[i].SPORT_NAME == "Badminton") {
                          int player1Set1 =
                              mapUserInfo?['Message']['PLAYER1_SCORE']['set1'];
                          int player1Set2 =
                              mapUserInfo?['Message']['PLAYER1_SCORE']['set2'];
                          int player1Set3 =
                              mapUserInfo?['Message']['PLAYER1_SCORE']['set3'];
                          int player2Set1 =
                              mapUserInfo?['Message']['PLAYER2_SCORE']['set1'];
                          int player2Set2 =
                              mapUserInfo?['Message']['PLAYER2_SCORE']['set2'];
                          int player2Set3 =
                              mapUserInfo?['Message']['PLAYER2_SCORE']['set3'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LiveMaintainer(
                                Tournament_ID: matchesdata[i].TOURNAMENT_ID,
                                Match_Id: matchesdata[i].MATCHID,
                                Player_1_name: matchesdata[i].PLAYER1_NAME,
                                Player1_Partner: matchesdata[i].PLAYER1_PARTNER,
                                Player_2_name: matchesdata[i].PLAYER2_NAME,
                                Player2_Partner: matchesdata[i].PLAYER2_PARTNER,
                                Player1_ID: matchesdata[i].PLAYER1_ID,
                                Player2_ID: matchesdata[i].PLAYER2_ID,
                                player1_set_1: player1Set1,
                                player1_set_2: player1Set2,
                                player1_set_3: player1Set3,
                                player2_set_1: player2Set1,
                                player2_set_2: player2Set2,
                                player2_set_3: player2Set3,
                              ),
                            ),
                          );
                        } else {
                          int player1Set1 =
                              mapUserInfo?['Message']['PLAYER1_SCORE']['set1'];
                          int player1Set2 =
                              mapUserInfo?['Message']['PLAYER1_SCORE']['set2'];
                          int player1Set3 =
                              mapUserInfo?['Message']['PLAYER1_SCORE']['set3'];
                          int player1Set4 =
                              mapUserInfo?['Message']['PLAYER1_SCORE']['set4'];
                          int player1Set5 =
                              mapUserInfo?['Message']['PLAYER1_SCORE']['set5'];
                          int player2Set1 =
                              mapUserInfo?['Message']['PLAYER2_SCORE']['set1'];
                          int player2Set2 =
                              mapUserInfo?['Message']['PLAYER2_SCORE']['set2'];
                          int player2Set3 =
                              mapUserInfo?['Message']['PLAYER2_SCORE']['set3'];
                          int player2Set4 =
                              mapUserInfo?['Message']['PLAYER2_SCORE']['set4'];
                          int player2Set5 =
                              mapUserInfo?['Message']['PLAYER2_SCORE']['set5'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LiveMaintainerTableTennis(
                                Tournament_ID: matchesdata[i].TOURNAMENT_ID,
                                Match_Id: matchesdata[i].MATCHID,
                                Player_1_name: matchesdata[i].PLAYER1_NAME,
                                Player1_Partner: matchesdata[i].PLAYER1_PARTNER,
                                Player_2_name: matchesdata[i].PLAYER2_NAME,
                                Player2_Partner: matchesdata[i].PLAYER2_PARTNER,
                                Player1_ID: matchesdata[i].PLAYER1_ID,
                                Player2_ID: matchesdata[i].PLAYER2_ID,
                                player1_set_1: player1Set1,
                                player1_set_2: player1Set2,
                                player1_set_3: player1Set3,
                                player1_set_4: player1Set4,
                                player1_set_5: player1Set5,
                                player2_set_1: player2Set1,
                                player2_set_2: player2Set2,
                                player2_set_3: player2Set3,
                                player2_set_4: player2Set4,
                                player2_set_5: player2Set5,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text("Start Scoring >",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: deviceWidth * 0.03,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Match Id :${int.parse(matchesdata[i].MATCHID) + 1}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              )
            ],
          ),
        );
        AllMatches.add(container);
      }
    }
    return AllMatches;
  }

  getAllHostedMatches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var obtianedEmail = prefs.getString('email');
    var url =
        "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/allMatches?TOURNAMENT_ID=${widget.Tournament_id}";
    var response = await get(Uri.parse(url));
    List<dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print("Didn't Receive");
    }
    print(jsonData);

    try {
      List<MatchesData> matchesdata =
          jsonData.map((dynamic item) => MatchesData.fromJson(item)).toList();
      int arrayLength = matchesdata.length;
      print(matchesdata);
      return getHostedMatches(matchesdata, arrayLength);
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    futures = getAllHostedMatches();
    // _getDetails();
    // _getDetails2();
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _refreshTournaments() async {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (a, b, c) => LiveMaintainerMatchSelection(
            Tournament_id: widget.Tournament_id,
          ),
        ),
      );
    }

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            PageRouteBuilder(pageBuilder: (a, b, c) => const HomePage()));
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: RefreshIndicator(
          onRefresh: () async {
            await _refreshTournaments();
          },
          child: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/Homepage.png"),
                  fit: BoxFit.cover,
                ),
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
                                      pageBuilder: (a, b, c) =>
                                          const HomePage()));
                            },
                            child: Container(
                              width: deviceWidth * 0.18,
                              height: deviceWidth * 0.1,
                              margin: EdgeInsets.fromLTRB(
                                  0, deviceWidth * 0.03, 0, 0),
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('assets/AARDENT_LOGO.png'),
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: deviceWidth * 0.026,
                            height: deviceWidth * 0.08,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/Ardent_Sport_Text.png"),
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
                    SizedBox(
                      height: deviceWidth * 0.06,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.04))),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        var email = prefs.getString('email');
                        Get.to(WebViewLiveMaintainerPreviewFixture(
                          Tourney_id: widget.Tournament_id,
                          userId: email,
                          SpotNo: "1",
                        ));
                      },
                      child: Text(
                        "Preview Fixture",
                        style: TextStyle(
                            color: Colors.white, fontSize: deviceWidth * 0.03),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                deviceWidth * 0.03, 0, 0, 0),
                            child: const Text("Current Matches")),
                        FutureBuilder(
                          future: futures,
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.data == null) {
                              return const Center(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              return Column(
                                children: snapshot.data,
                              );
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
