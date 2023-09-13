import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../event_detail/event_details.dart';
import '../cricket_create_challenge/cricket_create_challenge.dart';

class CreateChallenge extends StatefulWidget {
  const CreateChallenge({Key? key}) : super(key: key);

  @override
  State<CreateChallenge> createState() => _CreateChallengeState();
}

class _CreateChallengeState extends State<CreateChallenge> {
  List<String> Sports = [
    'Badminton',
    'Table Tennis',
    'Cricket',
  ];
  String? SelectedSport;

  List<String> Event = ['Fixed', 'Dynamic'];
  String? SelectedEvent;

  final EventManagerNameController = TextEditingController();
  final MobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Homepage.png"), fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: deviceHeight * 0.15,
                ),
                Text(
                  "Create Competition",
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: deviceWidth * 0.07,
                  ),
                ),
                SizedBox(
                  height: deviceWidth * 0.03,
                ),
                buildCard(deviceWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(double deviceWidth) => Card(
        elevation: 10,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.white.withOpacity(0.2),
        margin: EdgeInsets.only(
            left: deviceWidth * 0.05, right: deviceWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: deviceWidth * 0.04,
              ),
              Container(
                margin: EdgeInsets.all(deviceWidth * 0.04),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: DropdownButtonFormField(
                  hint: Text(
                    "Select Sport",
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: deviceWidth * 0.04,
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.red,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.06),
                    ),
                  ),
                  value: SelectedSport,
                  items: Sports.map((value) => DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      )).toList(),
                  onChanged: (value) {
                    setState(() {
                      SelectedSport = value as String;
                    });
                  },
                ),
              ),
              SizedBox(
                height: deviceWidth * 0.02,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        deviceWidth * 0.03, 0, deviceWidth * 0.01, 0),
                    child: Text(
                      "Event Manager Detail",
                      style: TextStyle(
                        fontSize: deviceWidth * 0.05,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        EasyLoading.instance.displayDuration =
                            const Duration(milliseconds: 15000);
                        EasyLoading.instance.radius = 15;
                        EasyLoading.showInfo(
                            "The event manager details will be displayed to all the players",
                            dismissOnTap: true);
                      },
                      icon: const Icon(Icons.info)),
                ],
              ),
              SizedBox(
                height: deviceWidth * 0.02,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    deviceWidth * 0.03, 0, deviceWidth * 0.03, 0),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  color: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: deviceWidth * 0.01,
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: EventManagerNameController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.04),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.04),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            hintText: "Name",
                            hintStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.02),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceWidth * 0.02,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            deviceWidth * 0.03, 0, deviceWidth * 0.03, 0),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04)),
                        child: TextField(
                          maxLength: 10,
                          controller: MobileNumberController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.04),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.04),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            hintText: "Mobile Number",
                            counterText: "",
                            hintStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.02),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceWidth * 0.02,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: deviceWidth * 0.03,
              ),
              Container(
                width: deviceWidth * 0.8,
                margin: EdgeInsets.fromLTRB(
                    deviceWidth * 0.04, 0, deviceWidth * 0.03, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(deviceWidth * 0.06)),
                  ),
                  onPressed: () {
                    if (SelectedSport == null ||
                        EventManagerNameController.text.isEmpty ||
                        MobileNumberController.text.isEmpty) {
                      const msg = "All Fields are Mandatory";
                      Fluttertoast.showToast(msg: msg);
                    } else if (SelectedSport == 'Cricket') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CricketChallenge(
                            SportName: SelectedSport,
                            EventManagerName: EventManagerNameController.text,
                            EventManagerMobileNo: MobileNumberController.text,
                            EventType: "Fixed",
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetails(
                            SportName: SelectedSport,
                            EventManagerName: EventManagerNameController.text,
                            EventManagerMobileNo: MobileNumberController.text,
                            EventType: "Fixed",
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: deviceWidth * 0.02,
              ),
            ],
          ),
        ),
      );
}
