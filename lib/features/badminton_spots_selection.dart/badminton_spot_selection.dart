import 'dart:async';
import 'dart:convert';
import 'package:ardent_sports/SpotConfirmation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helper/apis.dart';
import '../rules/rules.dart';
import '../my_bookings/my_bookings.dart';
import '../web_view/web_view_spots.dart';

int freespots = 0;
int entryfee = 0;
int prizepool = 0;
var array1 = [];
String? finalEmail;
Timer? timer;

class BadmintonSpotSelection extends StatefulWidget {
  final String tourneyId;
  final String sport;
  final String Date;
  final int spots;
  final String Organiser_Name;
  final String Organiser_Number;
  final String Address;
  final String subTournamentType;
  final String CategoryType;
  const BadmintonSpotSelection({
    Key? key,
    required this.tourneyId,
    required this.sport,
    required this.Date,
    required this.spots,
    required this.Organiser_Name,
    required this.Organiser_Number,
    required this.Address,
    required this.subTournamentType,
    required this.CategoryType,
  }) : super(key: key);

  @override
  State<BadmintonSpotSelection> createState() => _BadmintonSpotSelectionState();
}

late Color color1 = const Color(0xffffff00).withOpacity(0.8);

class tournament_id {
  late String TOURNAMENT_ID;
  tournament_id({required this.TOURNAMENT_ID});
  Map<String, dynamic> toMap() {
    return {"TOURNAMENT_ID": TOURNAMENT_ID};
  }
}

class SpotClickedDetails {
  late String TOURNAMENT_ID;
  late String index;
  String? USER;

  SpotClickedDetails(
      {required this.TOURNAMENT_ID, required this.index, required this.USER});
  Map<String, dynamic> toMap() {
    return {"TOURNAMENT_ID": TOURNAMENT_ID, "btnID": index, "USERID": USER};
  }
}

class Prize {
  late String gold;
  late String silver;
  late String bronze;

  Prize({required this.gold, required this.silver, required this.bronze});

  Map<String, dynamic> toMap() {
    return {"gold": gold, "silver": silver, "bronze": bronze};
  }
}

class json_decode_spotstatusarray {
  late int total_no_spots;
  var array = [];
  late int Prize_Pool;
  late int entry_fee;
  json_decode_spotstatusarray(
      this.total_no_spots, this.array, this.Prize_Pool, this.entry_fee);
  json_decode_spotstatusarray.fromJson(Map<String, dynamic> json) {
    total_no_spots = json['total_spots'];
    array = json['array'];
    Prize_Pool = json['prize_pool'];
    entry_fee = json['entry_fee'];
  }
}

class json_decode_spot_clicked_return {
  late String spot_number;
  late String color;
  json_decode_spot_clicked_return(this.spot_number, this.color);
  json_decode_spot_clicked_return.fromJson(Map<String, dynamic> json) {
    spot_number = json['btnID'];
    color = json['color'];
  }
}

class json_decode_confirm_clicked_return {
  late String spot_number;
  json_decode_confirm_clicked_return(this.spot_number);
  json_decode_confirm_clicked_return.fromJson(Map<String, dynamic> json) {
    spot_number = json['btnID'];
  }
}

class Search {
  late String USERID;
  Search({required this.USERID});
  Map<String, dynamic> toMap() {
    return {"PLAYER_2": USERID};
  }
}

class addPartner {
  late String TOURNAMENT_ID;
  late String SPOT_NUMBER;
  String? PLAYER_1;
  String PLAYER_2;

  addPartner(
      {required this.TOURNAMENT_ID,
      required this.SPOT_NUMBER,
      required this.PLAYER_1,
      required this.PLAYER_2});
  Map<String, dynamic> toMap() {
    return {
      "TOURNAMENT_ID": TOURNAMENT_ID,
      "SPOT_NUMBER": SPOT_NUMBER,
      "PLAYER_1": PLAYER_1,
      "PLAYER_2": PLAYER_2
    };
  }
}

class send_socket_number_ {
  late String spot_number;
  late String tourney_id;
  String? USER_ID;

  send_socket_number_(this.spot_number, this.tourney_id, this.USER_ID);
  Map<String, dynamic> toMap() {
    return {
      "TOURNAMENT_ID": tourney_id,
      "SPOTID": spot_number,
      "USERID": USER_ID,
    };
  }
}

class _BadmintonSpotSelectionState extends State<BadmintonSpotSelection> {
  int totalspots = 0;
  var count = 0;
  var isTournamentBooked = false;
  var isAdded = false;
  late Socket socket;
  @override
  List<Container> getTotalSpots(int start, int end, List<dynamic> array) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    List<Container> totalspots = [];
    for (int i = start; i <= end; i++) {
      String x = array[i - 1];
      String spotname = "Spot $i";
      if (array[i - 1] == "${i - 1}") {
        var newContainer = Container(
          margin: EdgeInsets.only(top: deviceWidth * 0.02),
          width: deviceWidth * 0.2,
          height: deviceHeight * 0.032,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6EBC55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(deviceWidth * 0.01),
              ),
            ),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              var obtianedEmail = prefs.getString('email');

              if (widget.CategoryType == "DOUBLES") {
                TextEditingController searchValue = TextEditingController();
                String addName = "Add +";
                String name = "Name";
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(top: deviceWidth * 0.3),
                          child: Dialog(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: deviceHeight * 0.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  // child: const Image(
                                  //   image: AssetImage(
                                  //       "assets/AddPlayerBackground.png"),
                                  // ),
                                ),
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Image(
                                                image: AssetImage(
                                                    "assets/back_edit.png"),
                                              )),
                                          const Text(
                                            "Add your partner",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const Text(""),
                                          const Text(""),
                                          const Text(""),
                                        ],
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.all(deviceWidth * 0.04),
                                        child: TextField(
                                          controller: searchValue,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      deviceWidth * 0.04),
                                              borderSide: BorderSide(
                                                color: Colors.white
                                                    .withOpacity(0.3),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      deviceWidth * 0.04),
                                              borderSide: BorderSide(
                                                color: Colors.white
                                                    .withOpacity(0.3),
                                              ),
                                            ),
                                            hintText:
                                                "Enter Partner's Email ID",
                                            hintStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      deviceWidth * 0.02),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final Search_details =
                                              Search(USERID: searchValue.text);
                                          final Search_detailsMap =
                                              Search_details.toMap();
                                          final json =
                                              jsonEncode(Search_detailsMap);
                                          EasyLoading.show(
                                              status: 'Searching...',
                                              maskType:
                                                  EasyLoadingMaskType.black);
                                          var response = await post(
                                              searchDoublesPartnerApi,
                                              headers: {
                                                "Accept": "application/json",
                                                "Content-Type":
                                                    "application/json"
                                              },
                                              body: json,
                                              encoding:
                                                  Encoding.getByName("utf-8"));
                                          EasyLoading.dismiss();
                                          Map<String, dynamic> jsonData =
                                              jsonDecode(response.body);
                                          print(response.body);
                                          if (jsonData["Message"] ==
                                              "User Found") {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext cotext) {
                                                  return Dialog(
                                                    child: Container(
                                                      width: 75,
                                                      height: 130,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10,
                                                                    top: 10),
                                                            child: Text(
                                                                "Name : ${jsonData["NAME"]}"),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10,
                                                                    top: 10),
                                                            child: Text(
                                                                "User Id : ${jsonData["USERID"]}"),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              final addPlayerDetails = addPartner(
                                                                  TOURNAMENT_ID:
                                                                      widget
                                                                          .tourneyId,
                                                                  SPOT_NUMBER: (i -
                                                                          1)
                                                                      .toString(),
                                                                  PLAYER_1:
                                                                      obtianedEmail!,
                                                                  PLAYER_2:
                                                                      jsonData[
                                                                          "USERID"]);
                                                              final addPlayerDetailsMap =
                                                                  addPlayerDetails
                                                                      .toMap();
                                                              final json =
                                                                  jsonEncode(
                                                                      addPlayerDetailsMap);

                                                              var response = await post(
                                                                  addDoublesPartnerApi,
                                                                  headers: {
                                                                    "Accept":
                                                                        "application/json",
                                                                    "Content-Type":
                                                                        "application/json"
                                                                  },
                                                                  body: json,
                                                                  encoding: Encoding
                                                                      .getByName(
                                                                          "utf-8"));
                                                              Map<String,
                                                                      dynamic>
                                                                  jsonData1 =
                                                                  jsonDecode(
                                                                      response
                                                                          .body);
                                                              print(response
                                                                  .body);
                                                              if (jsonData1[
                                                                      "Message"] ==
                                                                  "Added a player") {
                                                                debugPrint(
                                                                    "EmailFromSocket: $obtianedEmail");
                                                                debugPrint(
                                                                    "tournamentIDDDDDD:${widget.tourneyId}");
                                                                final tournament_id1 =
                                                                    SpotClickedDetails(
                                                                  TOURNAMENT_ID:
                                                                      widget
                                                                          .tourneyId,
                                                                  index: (i - 1)
                                                                      .toString(),
                                                                  USER:
                                                                      obtianedEmail,
                                                                );
                                                                final tournament_id1Map =
                                                                    tournament_id1
                                                                        .toMap();

                                                                final json_tournamentid =
                                                                    jsonEncode(
                                                                        tournament_id1Map);

                                                                if (!isTournamentBooked) {
                                                                  socket.emit(
                                                                      'spot-clicked',
                                                                      json_tournamentid);

                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    PageTransition(
                                                                      type: PageTransitionType
                                                                          .rightToLeftWithFade,
                                                                      child:
                                                                          SpotConfirmation(
                                                                        SpotNo:
                                                                            i.toString(),
                                                                        Date: widget
                                                                            .Date,
                                                                        socket:
                                                                            socket,
                                                                        btnId: (i -
                                                                                1)
                                                                            .toString(),
                                                                        tournament_id:
                                                                            widget.tourneyId,
                                                                        userEmail:
                                                                            obtianedEmail,
                                                                        sport: widget
                                                                            .sport,
                                                                        color: widget.sport ==
                                                                                'Badminton'
                                                                            ? const Color(0xff6BB8FF)
                                                                            : const Color(0xff03C289),
                                                                      ),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) =>
                                                                            AlertDialog(
                                                                      title: const Text(
                                                                          "You Have Already Booked this Tournament"),
                                                                      content:
                                                                          const Text(
                                                                              "Do you want to go to my booking?"),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.all(14),
                                                                            child:
                                                                                const Text(
                                                                              "NO",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        ),

                                                                        //one min
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.push(context,
                                                                                PageTransition(type: PageTransitionType.rightToLeftWithFade, child: const MyBookings()));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.all(14),
                                                                            child:
                                                                                const Text("YES", style: TextStyle(color: Colors.white)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }

                                                                // SOCKET ON
                                                                socket.on(
                                                                    'spot-clicked-return',
                                                                    (data) {
                                                                  Map<String,
                                                                          dynamic>
                                                                      spot_cliclked_return_details =
                                                                      jsonDecode(
                                                                          data);
                                                                  var details =
                                                                      json_decode_spot_clicked_return
                                                                          .fromJson(
                                                                              spot_cliclked_return_details);
                                                                  String
                                                                      spotnumber =
                                                                      details
                                                                          .spot_number;
                                                                  var timer =
                                                                      25;
                                                                  final socket_number = send_socket_number_(
                                                                      spotnumber,
                                                                      widget
                                                                          .tourneyId,
                                                                      finalEmail);
                                                                  print(
                                                                      spotnumber);
                                                                  final socket_number_map =
                                                                      socket_number
                                                                          .toMap();
                                                                  final json_socket_number =
                                                                      jsonEncode(
                                                                          socket_number_map);

                                                                  setState(() {
                                                                    array1[int.parse(
                                                                            spotnumber)] =
                                                                        "${finalEmail}";
                                                                    debugPrint(
                                                                        "Array:$array1");
                                                                  });
                                                                });
                                                              }
                                                            },
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.06,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.3,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: const Color(
                                                                    0xffd15858),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "Confirm",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        deviceWidth *
                                                                            0.033,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xffD15858),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Search",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: deviceWidth * 0.033,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Or",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        width: 198,
                                        height: 64,
                                        margin: const EdgeInsets.only(top: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () async {
                                              final addPlayerDetails =
                                                  addPartner(
                                                      TOURNAMENT_ID:
                                                          widget.tourneyId,
                                                      SPOT_NUMBER:
                                                          (i - 1).toString(),
                                                      PLAYER_1: obtianedEmail,
                                                      PLAYER_2: "N/A");
                                              final addPlayerDetailsMap =
                                                  addPlayerDetails.toMap();
                                              final json = jsonEncode(
                                                  addPlayerDetailsMap);

                                              var response = await post(
                                                  addDoublesPartnerApi,
                                                  headers: {
                                                    "Accept":
                                                        "application/json",
                                                    "Content-Type":
                                                        "application/json"
                                                  },
                                                  body: json,
                                                  encoding: Encoding.getByName(
                                                      "utf-8"));
                                              Map<String, dynamic> jsonData1 =
                                                  jsonDecode(response.body);
                                              print(response.body);
                                              if (jsonData1["Message"] ==
                                                  "Added a player") {
                                                debugPrint(
                                                    "EmailFromSocket: $obtianedEmail");
                                                debugPrint(
                                                    "tournamentIDDDDDD:${widget.tourneyId}");
                                                final tournament_id1 =
                                                    SpotClickedDetails(
                                                  TOURNAMENT_ID:
                                                      widget.tourneyId,
                                                  index: (i - 1).toString(),
                                                  USER: obtianedEmail,
                                                );
                                                final tournament_id1Map =
                                                    tournament_id1.toMap();

                                                final json_tournamentid =
                                                    jsonEncode(
                                                        tournament_id1Map);

                                                if (!isTournamentBooked) {
                                                  socket.emit('spot-clicked',
                                                      json_tournamentid);
                                                  print(widget.sport);
                                                  Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeftWithFade,
                                                      child: SpotConfirmation(
                                                        SpotNo: i.toString(),
                                                        Date: widget.Date,
                                                        socket: socket,
                                                        btnId:
                                                            (i - 1).toString(),
                                                        tournament_id:
                                                            widget.tourneyId,
                                                        userEmail:
                                                            obtianedEmail,
                                                        sport: widget.sport,
                                                        color: widget.sport ==
                                                                'Badminton'
                                                            ? const Color(
                                                                0xff6BB8FF)
                                                            : const Color(
                                                                0xff03C289),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (ctx) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          "You Have Already Booked this Tournament"),
                                                      content: const Text(
                                                          "Do you want to go to my booking?"),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(14),
                                                            child: const Text(
                                                              "NO",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),

                                                        //one min
                                                        TextButton(
                                                          onPressed: () {
                                                            print("pressed");
                                                            Navigator.push(
                                                                context,
                                                                PageTransition(
                                                                    type: PageTransitionType
                                                                        .rightToLeftWithFade,
                                                                    child:
                                                                        const MyBookings()));
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(14),
                                                            child: const Text(
                                                                "YES",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }

                                                // SOCKET  ON
                                                socket.on('spot-clicked-return',
                                                    (data) {
                                                  Map<String, dynamic>
                                                      spot_cliclked_return_details =
                                                      jsonDecode(data);
                                                  var details =
                                                      json_decode_spot_clicked_return
                                                          .fromJson(
                                                              spot_cliclked_return_details);
                                                  String spotnumber =
                                                      details.spot_number;
                                                  var timer = 25;
                                                  final socket_number =
                                                      send_socket_number_(
                                                          spotnumber,
                                                          widget.tourneyId,
                                                          finalEmail);
                                                  print(spotnumber);
                                                  final socket_number_map =
                                                      socket_number.toMap();
                                                  final json_socket_number =
                                                      jsonEncode(
                                                          socket_number_map);

                                                  setState(() {
                                                    array1[int.parse(
                                                            spotnumber)] =
                                                        "${finalEmail}";
                                                    debugPrint("Array:$array1");
                                                  });
                                                });
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Center(
                                                      child: Text(
                                                        "Partner not yet",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        "decided",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                const Image(
                                                    image: AssetImage(
                                                        "assets/right_back.png"))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                debugPrint("EmailFromSocket: $obtianedEmail");
                debugPrint("tournamentIDDDDDD:${widget.tourneyId}");
                final tournament_id1 = SpotClickedDetails(
                  TOURNAMENT_ID: widget.tourneyId,
                  index: (i - 1).toString(),
                  USER: obtianedEmail,
                );
                final tournament_id1Map = tournament_id1.toMap();

                final json_tournamentid = jsonEncode(tournament_id1Map);

                if (!isTournamentBooked) {
                  socket.emit('spot-clicked', json_tournamentid);
                  print(widget.sport);
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: SpotConfirmation(
                        SpotNo: i.toString(),
                        Date: widget.Date,
                        socket: socket,
                        btnId: (i - 1).toString(),
                        tournament_id: widget.tourneyId,
                        userEmail: obtianedEmail,
                        sport: widget.sport,
                        color: widget.sport == 'Badminton'
                            ? const Color(0xff6BB8FF)
                            : const Color(0xff03C289),
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title:
                          const Text("You Have Already Booked this Tournament"),
                      content: const Text("Do you want to go to my booking?"),
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

                        //one min
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    child: const MyBookings()));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: const Text("YES",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // SOCKET ON
                socket.on('spot-clicked-return', (data) {
                  Map<String, dynamic> spot_cliclked_return_details =
                      jsonDecode(data);
                  var details = json_decode_spot_clicked_return
                      .fromJson(spot_cliclked_return_details);
                  String spotnumber = details.spot_number;
                  var timer = 25;
                  final socket_number = send_socket_number_(
                      spotnumber, widget.tourneyId, finalEmail);
                  print(spotnumber);
                  final socket_number_map = socket_number.toMap();
                  final json_socket_number = jsonEncode(socket_number_map);

                  setState(() {
                    array1[int.parse(spotnumber)] = "${finalEmail}";
                    debugPrint("Array:$array1");
                  });
                });
              }
            },
            child: Text(
              spotname,
              style: TextStyle(fontSize: deviceWidth * 0.03),
            ),
          ),
        );
        totalspots.add(newContainer);
      } else if (x.contains('confirmed')) {
        var newContainer = Container(
          margin: EdgeInsets.only(top: deviceWidth * 0.02),
          width: deviceWidth * 0.2,
          height: deviceHeight * 0.032,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff808080),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(deviceWidth * 0.01),
              ),
            ),
            onPressed: () {
              const msg = "Spot Already Booked Please Try To Book Another Spot";
              Fluttertoast.showToast(
                  msg: msg,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: deviceWidth * 0.033);
            },
            child: Text(
              spotname,
              style: TextStyle(fontSize: deviceWidth * 0.03),
            ),
          ),
        );
        totalspots.add(newContainer);
      } else {
        var newContainer = Container(
          margin: EdgeInsets.only(top: deviceWidth * 0.02),
          width: deviceWidth * 0.2,
          height: deviceHeight * 0.032,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFFFF00).withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(deviceWidth * 0.01),
              ),
            ),
            onPressed: () {
              const msg =
                  'Someone is currently booking the spot please try to book another spot or wait for some-time';
              Fluttertoast.showToast(msg: msg);
            },
            key: Key(color1.toString()),
            child: Text(
              spotname,
              style: TextStyle(fontSize: deviceWidth * 0.03),
            ),
          ),
        );
        totalspots.add(newContainer);
      }
    }
    return totalspots;
  }

  connect(double deviceWidth, double deviceHeight) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var obtianedEmail = prefs.getString('email');
    socket.on('spot-clicked-return', (data) {
      Map<String, dynamic> spot_cliclked_return_details = jsonDecode(data);
      var details = json_decode_spot_clicked_return
          .fromJson(spot_cliclked_return_details);
      String spotnumber = details.spot_number;

      final socket_number =
          send_socket_number_(spotnumber, widget.tourneyId, finalEmail);
      print(spotnumber);
      final socket_number_map = socket_number.toMap();
      final json_socket_number = jsonEncode(socket_number_map);
      if (mounted) {
        setState(() {
          array1[int.parse(spotnumber)] = "${finalEmail}";
          super.deactivate();
        });
      }
    });
    socket.on('booking-confirmed', (data) {
      Map<String, dynamic> booking_confirmed_details = jsonDecode(data);
      var booking_details = json_decode_confirm_clicked_return
          .fromJson(booking_confirmed_details);
      String spotnumber = booking_details.spot_number;
      print("okok${spotnumber}");
      if (mounted) {
        setState(() {
          array1[int.parse(spotnumber)] = "confirmed-$finalEmail";
          super.deactivate();
        });
      }
    });
    socket.on('removed-from-waiting-list', (data) {
      print("removed from waiting list");
      setState(() {
        if (mounted) {
          setState(() {
            array1[int.parse(data['btnID'])] = data['btnID'];
            super.deactivate();
          });
        }
      });
    });
    socket.on('spotStatusArray', (data) {
      Map<String, dynamic> spot_details = jsonDecode(data);
      var details = json_decode_spotstatusarray.fromJson(spot_details);
      totalspots = details.total_no_spots;
      array1 = details.array;
      prizepool = details.Prize_Pool;
      entryfee = details.entry_fee;
      freespots = 0;
      bool isBooked = false;
      for (int i = 0; i < totalspots; i++) {
        if (array1[i] == "confirmed-$obtianedEmail") {
          isBooked = true;
        }
        if (array1[i] == "$i") {
          freespots = freespots + 1;
        }
      }
      if (count == 0) {
        if (mounted) {
          setState(() {
            count = 1;
            isTournamentBooked = isBooked;
            super.deactivate();
          });
        }
      }
    });

    print("is${array1}");
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              left: deviceWidth * 0.05, right: deviceWidth * 0.05),
          child: buildSpotsAvailableCard(deviceWidth, deviceHeight),
        ),
        Container(
          margin: EdgeInsets.only(
              left: deviceWidth * 0.05, right: deviceWidth * 0.05),
          child: buildAvailableSpotsCard(deviceWidth),
        ),
      ],
    );
  }

// http://44.202.65.121:443
  //http://ardentsportsapis-env.eba-wixhrshv.ap-south-1.elasticbeanstalk.com/
  var futures;
  void initState() {
    socket = io(
        "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000",
        <String, dynamic>{
          "transports": ["websocket"],
          "autoConnect": false,
          "forceNew": true,
        });
    socket.connect();
    final tournament_id1 = tournament_id(TOURNAMENT_ID: widget.tourneyId);
    final tournament_id1Map = tournament_id1.toMap();
    final json_tournamentid = jsonEncode(tournament_id1Map);
    if (mounted) {
      socket.emit('join-booking', json_tournamentid);
    }

    _getPrize();

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
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
                    TextButton(
                        onPressed: () {
                          Get.to(() => Rules(
                                tourneyId: widget.tourneyId,
                              ));
                        },
                        child: const Text(
                          "Rules >",
                          style:
                              TextStyle(color: Color(0xffD15858), fontSize: 20),
                        ))
                  ],
                ),
                FutureBuilder(
                  future: connect(deviceWidth, deviceHeight),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.data == null) {
                      return const Center(
                        child: Text("Loading..."),
                      );
                    } else {
                      return Column(
                        children: snapshot.data.children,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSpotsAvailableCard(double deviceWidth, double deviceHeight) =>
      SizedBox(
        height: deviceHeight * 0.105,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          color: widget.sport == 'Badminton'
              ? const Color(0xff6BB8FF)
              : const Color(0xff03C289),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Prize Pool",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: deviceWidth * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: deviceWidth * 0.25,
                    height: deviceWidth * 0.07,
                    child: Card(
                      elevation: 10,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0)),
                      color: Colors.black.withOpacity(0.25),
                      child: Text(
                        "₹$prizepool",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              // SizedBox(
              //   width: deviceWidth * 0.03,
              // ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      widget.subTournamentType,
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: deviceWidth * 0.045,
                      ),
                    ),
                  ),
                  Text(
                    "Draw",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: deviceWidth * 0.045,
                    ),
                  ),
                  SizedBox(
                    width: deviceWidth * 0.25,
                    height: deviceWidth * 0.07,
                    child: Card(
                      elevation: 10,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0)),
                      color: Colors.black.withOpacity(0.25),
                      child: Text(
                        "$freespots/$totalspots",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              // SizedBox(
              //   width: deviceWidth * 0.05,
              // ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Entry Fees  ",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        fontSize: deviceWidth * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: deviceWidth * 0.15,
                    height: deviceWidth * 0.07,
                    child: Card(
                      elevation: 10,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0)),
                      color: Colors.black.withOpacity(0.25),
                      child: Text(
                        "₹$entryfee",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );

  var prizepool;
  var prizepool2;
  var prizepool3;

  _getPrize() async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);

    var url = Uri.parse(
        'http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/prizeMoney?TOURNAMENT_ID=${widget.tourneyId}');

    var response = await get(url);

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      setState(() {
        prizepool = jsonData['GOLD'];
        print(prizepool);
        prizepool2 = jsonData['SILVER'];
        print(prizepool2);
        prizepool3 = jsonData['BRONZE'];
        print(prizepool3);
      });
    } else {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
    }
  }

  Widget buildAvailableSpotsCard(double deviceWidth) => Card(
        elevation: 10,
        color: Colors.white.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: deviceWidth * 0.04,
                  height: deviceWidth * 0.04,
                  color: const Color(0xff6EBC55),
                ),
                SizedBox(
                  width: 10,
                ),
                const Text("Vacant"),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: deviceWidth * 0.04,
                  height: deviceWidth * 0.04,
                  color: const Color(0xff808080),
                ),
                SizedBox(
                  width: 10,
                ),
                const Text("Booked"),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: deviceWidth * 0.04,
                  height: deviceWidth * 0.04,
                  color: const Color(0xffFFFF00).withOpacity(0.8),
                ),
                SizedBox(
                  width: 10,
                ),
                const Text("Processing"),
              ],
            ),
            SizedBox(
              height: deviceWidth * 0.03,
            ),
            Row(children: [
              SizedBox(
                width: deviceWidth * 0.05,
                height: deviceWidth * 0.06,
              ),
              Column(
                children: getTotalSpots(1, (totalspots / 2).toInt(), array1),
              ),
              SizedBox(
                width: deviceWidth * 0.4,
                height: deviceWidth * 0.24,
              ),
              Column(
                children: getTotalSpots(
                    (totalspots / 2).toInt() + 1, totalspots, array1),
              ),
            ]),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: deviceWidth * 0.3,
                height: deviceWidth * 0.07,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffD15858),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.01),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: WebViewSpots(
                                spots: "${widget.spots}",
                              )));
                    },
                    child: const Text(
                      "Fixtures",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: deviceWidth * 0.05),
              child: const Text(
                "Note :",
                style: TextStyle(
                    color: Color(0xffD15858), fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Container(
              margin: EdgeInsets.only(left: deviceWidth * 0.05),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                        text: '->  Match will be played according to the '),
                    TextSpan(
                      text: 'Fixtures',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: WebViewSpots(
                                spots: "${widget.spots}",
                              ),
                            ),
                          );
                        },
                    ),
                    const TextSpan(text: ' so select the spot accordingly '),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Container(
              margin: EdgeInsets.only(left: deviceWidth * 0.05),
              child: const Text(
                "-> Spots Cannot be changed once selected",
                style: TextStyle(color: Color(0xffFFFFFF)),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Container(
              margin: EdgeInsets.only(left: deviceWidth * 0.05),
              child: const Text(
                "Organizer Details :",
                style: TextStyle(
                    color: Color(0xffD15858), fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Container(
              margin: EdgeInsets.only(left: deviceWidth * 0.05),
              child: Text(
                "-> Organizer Name : ${widget.Organiser_Name}",
                style: const TextStyle(color: Color(0xffFFFFFF)),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Container(
              margin: EdgeInsets.only(left: deviceWidth * 0.05),
              child: Text(
                "-> Organizer Number : ${widget.Organiser_Number}",
                style: const TextStyle(color: Color(0xffFFFFFF)),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Container(
              margin: EdgeInsets.only(left: deviceWidth * 0.05),
              child: Text(
                "-> Address : ${widget.Address}",
                style: const TextStyle(color: Color(0xffFFFFFF)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffD15858),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.01),
                    ),
                  ),
                  onPressed: () {
                    showSheet();
                  },
                  child: const Text(
                    "Show Prize Money",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );

  void showSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Stack(
          alignment: Alignment.center,
          children: [
            const Image(
              image: AssetImage("assets/PrizeBackGround.png"),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "Gold",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 70,
                  width: 299,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/GoldTrophy.png',
                        ),
                        Image.asset('assets/cross shape.png'),
                        Text("₹ $prizepool",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                      color: const Color(0xffCECECE),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "Silver",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 70,
                  width: 299,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/silver-cup 1.png',
                        ),
                        Image.asset('assets/cross shape.png'),
                        Text("₹ $prizepool2",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                      color: const Color(0xffCD7F32),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "Bronze",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 70,
                  width: 299,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/BronzeTrophy.png',
                      ),
                      Image.asset('assets/cross shape.png'),
                      Text(
                        "₹ $prizepool3",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
// git clone -b codeStructure https://oauth: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@github.com/viewo-com/chat-support-app.git