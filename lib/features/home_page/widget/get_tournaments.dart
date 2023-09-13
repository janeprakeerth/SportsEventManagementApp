import 'dart:convert';
import 'package:ardent_sports/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import '../../badminton_spots_selection.dart/badminton_spot_selection.dart';
import '../home_page.dart';

List<Card> getTournaments(
  List<UserData> userdata,
  int arrayLength,
  BuildContext context,
) {
  double deviceWidth = MediaQuery.of(context).size.width;
  double deviceHeight = MediaQuery.of(context).size.height;
  late Color color = Colors.blue;
  for (int i = arrayLength - 1; i >= 0; i--) {
    var container = Card(
      margin: EdgeInsets.all(deviceWidth * 0.04),
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
            title: SizedBox(
              height: MediaQuery.of(context).size.height * 0.075,
              child: InkWell(
                onTap: () async {
                  EasyLoading.instance.displayDuration =
                      const Duration(milliseconds: 15000);
                  EasyLoading.instance.radius = 15;
                  EasyLoading.showInfo(
                      "Tournament Name : ${userdata[i].TOURNAMENT_NAME}",
                      dismissOnTap: true);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: userdata[i].SPORT == 'Badminton'
                            ? const Color(0xff6BB8FF)
                            : const Color(0xff03C289)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: deviceWidth * 0.1,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: deviceHeight * 0.09,
                          width: deviceWidth * 0.09,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 15.0,
                                ),
                              ],
                              color: Colors.transparent.withOpacity(0.5),
                              backgroundBlendMode: BlendMode.darken),
                          child: Image(
                            image: NetworkImage(
                              userdata[i].IMG_URL,
                            ),
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
                              userdata[i].TOURNAMENT_NAME.length > 12
                                  ? userdata[i]
                                          .TOURNAMENT_NAME
                                          .substring(0, 30) +
                                      '...'
                                  : userdata[i].TOURNAMENT_NAME,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 123, 81, 81)),
                            ),
                            SizedBox(
                              height: 05,
                            ),
                            Text(
                              userdata[i].CITY,
                              style: TextStyle(
                                fontSize: 14,
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
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(deviceWidth * 0.04),
              ),
              elevation: 1,
              color: Colors.transparent.withOpacity(0.2),
              child: ExpansionTile(
                trailing: Icon(
                  Icons.arrow_drop_down_circle,
                  color: userdata[i].SPORT == 'Badminton'
                      ? const Color(0xff6BB8FF)
                      : const Color(0xff03C289),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Container(
                        margin: EdgeInsets.only(left: deviceWidth * 0.02),
                        child: const Text(
                          "Category",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: deviceWidth * 0.02),
                      child: const Text(
                        "Spots Left",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                children: getAllTournamentCategories(
                  userdata[i].spotStatusArray,
                  userdata[i].START_DATE,
                  userdata[i].ORGANIZER_NAME,
                  userdata[i].ORGANIZER_ID,
                  userdata[i].SPORT,
                  userdata[i].LOCATION,
                  userdata[i].CATEGORY,
                  context,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
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
                      ),
                    ),
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
                              text: "₹",
                              style: TextStyle(
                                fontSize: deviceWidth * 0.05,
                              ),
                            ),
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(deviceWidth * 0.02),
                      child: const Image(
                        image: AssetImage("assets/Location.png"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        EasyLoading.instance.displayDuration =
                            const Duration(milliseconds: 15000);
                        EasyLoading.instance.radius = 15;
                        EasyLoading.showInfo(
                            "Tournament Address : ${userdata[i].LOCATION}",
                            dismissOnTap: true);
                      },
                      child: Text(
                        userdata[i].LOCATION.length > 20
                            ? userdata[i].LOCATION.substring(0, 20) + '...'
                            : userdata[i].LOCATION,
                        style: TextStyle(
                            color: Colors.white, fontSize: deviceWidth * 0.03),
                      ),
                    ),
                  ],
                ),
                // const Flexible(fit: FlexFit.tight, child: SizedBox()),
                Container(
                  padding: EdgeInsets.all(deviceWidth * 0.02),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.red),
                      SizedBox(
                        width: deviceWidth * 0.02,
                      ),
                      Column(
                        children: [
                          Text(
                            userdata[i].START_DATE,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: deviceWidth * 0.03,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${(userdata[i].START_TIME)} - ${(userdata[i].END_TIME)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: deviceWidth * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
    homePagedProvider!.AllTournaments.add(container);
  }
  return homePagedProvider!.AllTournaments;
}

List<Container> getAllTournamentCategories(
  List spotStatusArray,
  String Date,
  String Organizer_Name,
  String Organizer_Number,
  String tournament,
  String Address,
  String category,
  BuildContext context,
) {
  double deviceWidth = MediaQuery.of(context).size.width;
  double deviceHeight = MediaQuery.of(context).size.height;
  List<Container> AllCategories = [];
  int array_length = spotStatusArray.length;
  for (int i = 0; i < array_length; i++) {
    int x = spotStatusArray[i]['array'].length;
    int y = 0;
    for (int j = 0; j < x; j++) {
      if (spotStatusArray[i]['array'][j] == "$j") {
        y++;
      }
    }
    var container = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: InkWell(
              onTap: () async {
                EasyLoading.show(
                    status: 'Loading...',
                    indicator: const SpinKitThreeBounce(
                      color: Color(0xFFE74545),
                    ),
                    maskType: EasyLoadingMaskType.black);
                var url =
                    "http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/isTimeExceeded?TOURNAMENT_ID=${spotStatusArray[i]['id']}";
                var response = await get(Uri.parse(url));

                Map<String, dynamic> jsonData = jsonDecode(response.body);
                if (jsonData['Message'] == "false" &&
                    spotStatusArray[i]['STATUS'] == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BadmintonSpotSelection(
                        tourneyId: spotStatusArray[i]['id'],
                        sport: spotStatusArray[i]['SPORT'],
                        Date: Date,
                        spots: x,
                        Organiser_Name: Organizer_Name,
                        Organiser_Number: Organizer_Number,
                        Address: Address,
                        subTournamentType: spotStatusArray[i]['category_name'],
                        CategoryType: spotStatusArray[i]['CATEGORY_TYPE'],
                      ),
                    ),
                  );
                  EasyLoading.dismiss();
                } else if (spotStatusArray[i]['STATUS'] == false) {
                  EasyLoading.showError(
                      "Tournament has been completed. You can't join this tournament anymore");
                } else {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: const Text("Time Exceeded!"),
                            content: const Text(
                                "This Tournament Booking time has been exceeded"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ));
                  EasyLoading.dismiss();
                  print("Time Exceeded");
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Container(
                  height: deviceHeight * 0.03,
                  width: deviceWidth * 0.4,
                  decoration: BoxDecoration(
                    color: tournament == 'Badminton'
                        ? const Color(0xff6BB8FF)
                        : const Color(0xff03C289),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: tournament == 'Cricket'
                            ? const Text(
                                "Cricket Spot Selection",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                spotStatusArray[i]['category'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: deviceWidth * 0.22222222),
            child: Text(
              "$y/$x",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
    AllCategories.add(container);
  }
  return AllCategories;
}
