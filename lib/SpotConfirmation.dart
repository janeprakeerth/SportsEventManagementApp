import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'Helper/constant.dart';
import 'features/payment/payment.dart';

class jsonSpotNumber {
  late int spotNumber;
  late String Tournamen_id;
  late String User_id;
  jsonSpotNumber(
      {required this.spotNumber,
      required this.Tournamen_id,
      required this.User_id});
  Map<String, dynamic> toMap() {
    return {
      "btnId": spotNumber,
      "TOURNAMENT_ID": Tournamen_id,
      "USERID": User_id
    };
  }
}

class SpotConfirmation extends StatefulWidget {
  final String SpotNo;
  String? userEmail;
  final String tournament_id;
  final String Date;
  final Socket socket;
  final String btnId;
  final String sport;
  final Color color;
  SpotConfirmation({
    Key? key,
    required this.SpotNo,
    required this.userEmail,
    required this.tournament_id,
    required this.Date,
    required this.socket,
    required this.btnId,
    required this.sport,
    required this.color,
  }) : super(key: key);

  @override
  State<SpotConfirmation> createState() => _SpotConfirmationState();
}

class UserDetails {
  late String name;
  late String tournamentName;
  late String tournamentCity;
  late String address;
  late String entryFee;
  late String category;

  UserDetails(
    this.name,
    this.tournamentName,
    this.tournamentCity,
    this.address,
    this.entryFee,
    this.category,
  );

  UserDetails.fromJson(Map<String, dynamic> json) {
    name = json['username'];
    tournamentName = json['tournament_name'];
    tournamentCity = json['tournament_city'];
    address = json['address'];
    entryFee = json['fee'];
    category = json['cat'];
  }
}

Map? mapUserResponse;

class _SpotConfirmationState extends State<SpotConfirmation> {
  Future fetchUser() async {
    print("${widget.userEmail} ${widget.tournament_id}");
    http.Response response;
    response = await http.get(Uri.parse(
        'http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/getConfirmationDetails?USERID=${widget.userEmail}&TOURNAMENT_ID=${widget.tournament_id}'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        mapUserResponse = json.decode(response.body);
        print("ResponseBody:${response.body}");
      });
    }
  }

  @override
  void initState() {
    print("${widget.userEmail} okoko");
    fetchUser();
    super.initState();
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
                  image: AssetImage("assets/Homepage.png"), fit: BoxFit.cover)),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "<",
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      )),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    left: deviceWidth * 0.05, right: deviceWidth * 0.05),
                child: SpotConfirmationCard(deviceWidth),
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget SpotConfirmationCard(double deviceWidth) => Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(deviceWidth * 0.03),
            side: BorderSide(
              color: widget.color,
            )),
        elevation: 10,
        color: Colors.white.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: deviceWidth * 0.06,
            ),
            SizedBox(
              width: deviceWidth * 0.34,
              height: deviceWidth * 0.08,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceWidth * 0.08),
                  ),
                ),
                child: Text(
                  "Spot No : ${widget.SpotNo}",
                  style: TextStyle(
                      fontSize: deviceWidth * 0.04,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.03,
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.02),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceWidth * 0.03),
                    side: BorderSide(
                      color: widget.color,
                    )),
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: deviceWidth * 0.05,
                            right: deviceWidth * 0.05,
                            top: deviceWidth * 0.04,
                            bottom: deviceWidth * 0.04),
                        width: deviceWidth * 0.6,
                        height: deviceWidth * 0.08,
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          const TextSpan(
                              text: "Name : ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: "${mapUserResponse?['username']}",
                          ),
                        ])),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.02),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceWidth * 0.03),
                    side: BorderSide(
                      color: widget.color,
                    )),
                elevation: 10,
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      child: Container(
                        margin: EdgeInsets.only(
                          left: deviceWidth * 0.05,
                          right: deviceWidth * 0.05,
                          top: deviceWidth * 0.04,
                          bottom: deviceWidth * 0.04,
                        ),
                        width: deviceWidth * 0.6,
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          const TextSpan(
                              text: "Event : ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: "${mapUserResponse?['tournament_name']}",
                          ),
                        ])),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.02),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceWidth * 0.03),
                    side: BorderSide(
                      color: widget.color,
                    )),
                elevation: 10,
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: deviceWidth * 0.05,
                            right: deviceWidth * 0.05,
                            top: deviceWidth * 0.04),
                        width: deviceWidth * 0.6,
                        height: deviceWidth * 0.08,
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          const TextSpan(
                              text: "Category : ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: "${mapUserResponse?['cat']}",
                          ),
                        ])),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.01),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceWidth * 0.03),
                    side: BorderSide(
                      color: widget.color,
                    )),
                elevation: 10,
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: deviceWidth * 0.05,
                            right: deviceWidth * 0.05,
                            top: deviceWidth * 0.04),
                        width: deviceWidth * 0.6,
                        height: deviceWidth * 0.08,
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          const TextSpan(
                              text: "Date : ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: widget.Date,
                          ),
                        ])),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.02),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceWidth * 0.03),
                    side: BorderSide(
                      color: widget.color,
                    )),
                elevation: 10,
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: deviceWidth * 0.05,
                            right: deviceWidth * 0.05,
                            top: deviceWidth * 0.04,
                            bottom: deviceWidth * 0.04),
                        width: deviceWidth * 0.6,
                        height: deviceWidth * 0.08,
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          const TextSpan(
                              text: "Address : ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: "${mapUserResponse?['address']}",
                          ),
                        ])),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.05,
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.02),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceWidth * 0.03),
                    side: BorderSide(
                      color: widget.color,
                    )),
                elevation: 10,
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      color: Colors.black.withOpacity(0.3),
                      child: Container(
                        margin: EdgeInsets.only(
                            left: deviceWidth * 0.05,
                            right: deviceWidth * 0.05,
                            top: deviceWidth * 0.04),
                        width: deviceWidth * 0.6,
                        height: deviceWidth * 0.08,
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          const TextSpan(
                              text: "City : ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: "${mapUserResponse?['tournament_city']}",
                          ),
                        ])),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.1,
            ),
            SizedBox(
              width: deviceWidth * 0.6,
              height: deviceWidth * 0.08,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: Payment(
                          userId: widget.userEmail,
                          tourneyId: widget.tournament_id,
                          tourneyName: mapUserResponse?['tournament_name'],
                          entryFee: mapUserResponse?['fee'],
                          sportName: widget.sport,
                          location: mapUserResponse?['tournament_city'],
                          date: widget.Date,
                          spotNo: widget.SpotNo,
                          category: mapUserResponse?['cat'],
                          socket: widget.socket,
                        ),
                      ));
                
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE74745),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceWidth * 0.05),
                  ),
                ),
                child: Text(
                  "Confirm & Pay",
                  style: TextStyle(fontSize: deviceWidth * 0.05),
                ),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            )
          ],
        ),
      );
}
