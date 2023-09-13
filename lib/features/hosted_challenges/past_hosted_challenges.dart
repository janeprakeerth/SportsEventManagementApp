import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helper/constant.dart';
import '../../Model/user_model.dart';
import '../home_page/home_page.dart';

class PastHostedChallenges extends StatefulWidget {
  const PastHostedChallenges({Key? key}) : super(key: key);

  @override
  State<PastHostedChallenges> createState() => _PastHostedChallengesState();
}

class _PastHostedChallengesState extends State<PastHostedChallenges> {
  var futures;
  var futures_past_hosted_challenges;
  List<Container> AllTournaments = [];

  List<Container> getHostedTournaments(
      List<UserData> userdata, int array_length) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    if (array_length == 0) {
      var container = Container(
        margin: EdgeInsets.fromLTRB(deviceWidth * 0.03, 0, 0, 0),
        child: const Text("You Dont Have Any Hosted Challenges"),
      );
      AllTournaments.add(container);
    } else {
      for (int i = 0; i < array_length; i++) {
        var container = Container(
          height: MediaQuery.of(context).size.height * 0.43,
          padding: EdgeInsets.all(deviceWidth * 0.018),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(deviceWidth * 0.03),
            ),
            elevation: 10,
            color: Colors.white60.withOpacity(0.1),
            child: Column(
              //MAIN COLUMN
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
                      //           tourneyId: userdata[i].TOURNAMENT_ID,
                      //         )));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      elevation: 20,
                      color: userdata[i].SPORT == 'Badminton'
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
                              image: NetworkImage(userdata[i].IMG_URL),
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
                            children: [
                              Text(
                                userdata[i].TOURNAMENT_NAME.length > 25
                                    ? userdata[i]
                                            .TOURNAMENT_NAME
                                            .substring(0, 25) +
                                        '...'
                                    : userdata[i].TOURNAMENT_NAME,
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
                                userdata[i].CITY,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.018),
                    ),
                    elevation: 1,
                    color: Colors.transparent.withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: deviceWidth * 0.07),
                            child: const Text(
                              "Category",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "V",
                              style: TextStyle(
                                fontSize: deviceWidth * 0.04,
                                color: const Color(0xffE74545),
                              ),
                            )),
                        Container(
                            margin: EdgeInsets.only(right: deviceWidth * 0.07),
                            child: const Text(
                              "Spots Left",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
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
                                  image:
                                      const AssetImage("assets/trophy 2.png"),
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
                                  text: userdata[i].PRIZE_POOL.toString(),
                                  style: TextStyle(
                                      fontSize: deviceWidth * 0.05,
                                      color: const Color(0xffE74545),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
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
                        userdata[i].LOCATION,
                        style: TextStyle(
                            color: Colors.white, fontSize: deviceWidth * 0.03),
                      ),
                    ),
                  ],
                ),
                Text(
                  "TournamentID:${userdata[i].TOURNAMENT_ID}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: deviceWidth * 0.03,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        );
        AllTournaments.add(container);
      }
    }
    return AllTournaments;
  }

  getAllPastHostedTournaments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var obtianedEmail = prefs.getString('email');
    var url =
        "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/pastTournaments?USERID=$obtianedEmail";
    var response = await get(Uri.parse(url));
    List<dynamic> jsonData = jsonDecode(response.body);

    print(jsonData);
    try {
      List<UserData> userdata =
          jsonData.map((dynamic item) => UserData.fromJson(item)).toList();
      int array_length = userdata.length;
      print(userdata);
      return getHostedTournaments(userdata, array_length);
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    futures = getAllPastHostedTournaments();
    // futures_past_hosted_challenges = getAllPastHostedTournaments();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
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
                                pageBuilder: (a, b, c) => const HomePage(),
                              ),
                            );
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
                          width: deviceWidth * 0.26,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin:
                              EdgeInsets.fromLTRB(deviceWidth * 0.03, 0, 0, 0),
                          child: const Text(
                            "Past Hosted Challenges",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w800,
                            ),
                          )),
                      SizedBox(
                        height: deviceWidth * 0.05,
                      ),
                      FutureBuilder(
                        future: futures,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.data == null) {
                            print("In Null");
                            return const Center(
                              child: Text("You don't have any past challenges"),
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
    );
  }
}
