import 'dart:convert';
import 'package:ardent_sports/ticket.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../cricket_module/cricket_team_selection.dart';
import 'package:get/get.dart';
import '../../Model/user_model.dart';
import '../home_page/home_page.dart';
import '../web_view/web_view_test.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  State<MyBookings> createState() => _MyBookings();
}

class _MyBookings extends State<MyBookings> {
  var futures;
  List<Container> AllUpcomingHostedTournaments = [];

  List<Container> AllTournaments = [];

  List<Container> getHostedTournaments(
      List<UserData> userdata, int array_length) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    if (array_length == 0) {
      var container = Container(
        margin: EdgeInsets.fromLTRB(deviceWidth * 0.03, 0, 0, 0),
        child: const Text("You Do not have any Bookings"),
      );
      AllTournaments.add(container);
    } else {
      for (int i = array_length - 1; i >= 0; i--) {
        var container = Container(
          height: MediaQuery.of(context).size.height * 0.35,
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
                            height: deviceHeight * 0.09,
                            width: deviceWidth * 0.09,
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                        userdata[i].LOCATION,
                        style: TextStyle(
                            color: Colors.white, fontSize: deviceWidth * 0.03),
                        maxLines: 3,
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
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.04),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            EasyLoading.show(
                                status: 'Loading...',
                                indicator: const SpinKitThreeBounce(
                                  color: Color(0xFFE74545),
                                ),
                                maskType: EasyLoadingMaskType.black);
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var obtianedEmail = prefs.getString('email');
                            var url =
                                "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/ticket?TOURNAMENT_ID=${userdata[i].TOURNAMENT_ID}&USERID=$obtianedEmail";
                            var response = await get(Uri.parse(url));

                            try {
                              Map<String, dynamic> jsonData =
                                  jsonDecode(response.body);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ticket(
                                    spotNo: jsonData["SPOT"].toString(),
                                    location: jsonData["LOCATION"],
                                    eventName: jsonData["TNAME"],
                                    sportName: jsonData["SPORT"],
                                    name: jsonData["USRNAME"],
                                    category: jsonData["CATEGORY"],
                                    date: jsonData["DATE"],
                                  ),
                                ),
                              );

                              EasyLoading.dismiss();
                            } catch (e) {
                              print("exception ::: $e");
                              EasyLoading.showError("Error Loading Ticket");
                            }
                          },
                          child: const Text("Ticket >",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        )),
                    userdata[i].SPORT == "Cricket"
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.055,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                              color: const Color(0xffE74545),
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.04),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                var url3 = "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/hasTourneyStarted?TOURNAMENT_ID=${userdata[i]
                                    .TOURNAMENT_ID}";
                                var resp = await get(Uri.parse(url3));
                                print(resp.body);

                                if (resp.body == "false") {
                                  final cricketdetail = {
                                    "TOURNAMENT_ID": userdata[i].TOURNAMENT_ID
                                  };
                                  var finaldetails = jsonEncode(cricketdetail);
                                  // print(finaldetails);
                                  var url2 =
                                      "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/getCricketTourneyDetails";
                                  var response2 = await post(Uri.parse(url2),
                                      body: finaldetails,
                                      headers: {
                                        "Content-Type": "application/json"
                                      });
                                  var jsonData2 = jsonDecode(response2.body);
                                  print(jsonData2["TEAM_SIZE"]);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          CricketTeamDetails(
                                              id: jsonData2["_id"],
                                              TOURNAMENT_ID:
                                              jsonData2["TOURNAMENT_ID"],
                                              TEAM_SIZE: jsonData2["TEAM_SIZE"],
                                              SUBSTITUTE: jsonData2["SUBSTITUTE"],
                                              OVERS: jsonData2["OVERS"],
                                              BALL_TYPE: jsonData2["BALL_TYPE"])));
                                } else{
                                  print("In else before error : ");
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content: Text(resp.body)));
                                }
                              },
                              child: Center(
                                child: Text("Edit Team",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: deviceWidth * 0.035,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ))
                        : const Text(""),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.055,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        color: const Color(0xffE74545),
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          EasyLoading.show(
                              status: 'Loading...',
                              indicator: const SpinKitThreeBounce(
                                color: Color(0xFFE74545),
                              ),
                              maskType: EasyLoadingMaskType.black);
                          final prefs = await SharedPreferences.getInstance();
                          var id = prefs.getString('email');
                          var obtianedEmail = prefs.getString('email');
                          var url =
                              "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/ticket?TOURNAMENT_ID=${userdata[i].TOURNAMENT_ID}&USERID=$obtianedEmail";
                          var response = await get(Uri.parse(url));
                          Map<String, dynamic> jsonData =
                              jsonDecode(response.body);
                          EasyLoading.dismiss();
                          print(userdata[i].SPORT);
                          if(userdata[i].SPORT == 'Cricket'){
                            var url3 = "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/hasTourneyStarted?TOURNAMENT_ID=${userdata[i]
                                .TOURNAMENT_ID}";
                            var resp = await get(Uri.parse(url3));
                            print(resp.body);
                            if(resp.body == "false"){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewTest(
                                    userId: id,
                                    Tourney_id: userdata[i].TOURNAMENT_ID,
                                    SpotNo: jsonData["SPOT"].toString(),
                                    Sport: 'cricket',
                                  ),
                                ),
                              );
                            } else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewTest(
                                    userId: id,
                                    Tourney_id: userdata[i].TOURNAMENT_ID,
                                    SpotNo: jsonData["SPOT"].toString(),
                                    Sport: userdata[i].SPORT,
                                  ),
                                ),
                              );
                            }
                          } else{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewTest(
                                  userId: id,
                                  Tourney_id: userdata[i].TOURNAMENT_ID,
                                  SpotNo: jsonData["SPOT"].toString(),
                                  Sport: userdata[i].SPORT,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text("Fixtures >",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
        AllTournaments.add(container);
      }
    }
    return AllTournaments;
  }

  getAllHostedTournaments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var obtianedEmail = prefs.getString('email');
    var url =
        "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/myBookings?USERID=$obtianedEmail";
    var response = await get(Uri.parse(url));
    print('url : ${url} response ::  ${response.body.toString()}');
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      try {
        List<UserData> userdata = (jsonData as List)
            .map(
              (data) => UserData.fromJson(data),
            )
            .toList();
        int array_length = userdata.length;
        print(userdata);
        return getHostedTournaments(userdata, array_length);
      } catch (e) {
        print("exception ===>: $e");
      }
    } else {
      print("Didn't Receive");
    }
    print(jsonData);
  }

  void initState() {
    super.initState();
    futures = getAllHostedTournaments();
  }

  @override
  Widget build(BuildContext context) {
    print("print");
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Homepage.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (a, b, c) => const HomePage()));
                    },
                    child: Container(
                      width: deviceWidth * 0.2,
                      height: deviceHeight * 0.07,
                      margin: EdgeInsets.fromLTRB(0, deviceWidth * 0.03, 0, 0),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/AARDENT_LOGO.png'),
                        fit: BoxFit.cover,
                      )),
                    ),
                  ),
                  Container(
                    width: deviceWidth * 0.2,
                    height: deviceHeight * 0.08,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/Ardent_Sport_Text.png"),
                            fit: BoxFit.fitWidth)),
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
                  onPressed: () {
                    Get.to(const HomePage());
                  },
                  child: Text(
                    "Join a Tournament",
                    style: TextStyle(
                        color: Colors.white, fontSize: deviceWidth * 0.03),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(deviceWidth * 0.03, 0, 0, 0),
                      child: const Text("My Bookings")),
                  FutureBuilder(
                    future: futures,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: Text("Loading..."),
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
    );
  }
}
