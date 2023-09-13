import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Model/category_details_model.dart';
import '../../Helper/constant.dart';
import '../cricket_pool_detail/cricket_pool_details.dart';

class CricketChallenge extends StatefulWidget {
  final String? SportName;
  final String EventManagerName;
  final String EventManagerMobileNo;
  final String? EventType;

  const CricketChallenge({
    Key? key,
    required this.SportName,
    required this.EventManagerName,
    required this.EventManagerMobileNo,
    required this.EventType,
  }) : super(key: key);

  @override
  State<CricketChallenge> createState() => _CricketChallengeState();
}

class _CricketChallengeState extends State<CricketChallenge> {
  @override
  TextEditingController EventName = TextEditingController();
  TextEditingController startdateinput = TextEditingController();
  TextEditingController enddateinput = TextEditingController();
  TextEditingController starttime = TextEditingController();
  TextEditingController endtime = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController Address = TextEditingController();

  String? RegClosesHrs;
  List<String> RegCloses = ['2hrs', '6hrs', '12hrs', '24hrs'];

  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Homepage.png"),
                    fit: BoxFit.cover)),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: deviceWidth * 0.03,
                    ),
                    buildCardEventDetails(deviceWidth),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  List<CategorieDetails> AllCategories = [];
  @override
  void initState() {
    super.initState();
    AllCategories.add(CategorieDetails("Tournament", "Cricket"));
  }

  Widget buildCardEventDetails(double deviceWidth) => Card(
        elevation: 10,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        color: Colors.white.withOpacity(0.1),
        margin: EdgeInsets.only(
            left: deviceWidth * 0.05, right: deviceWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: deviceWidth * 0.04,
            ),
            Text(
              "    Event Name",
              style: TextStyle(
                fontSize: deviceWidth * 0.05,
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  deviceWidth * 0.04, 0, deviceWidth * 0.04, 0),
              child: TextField(
                controller: EventName,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.01),
                      borderSide: const BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                      borderSide: const BorderSide(),
                    ),
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                    )),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  deviceWidth * 0.04, 0, deviceWidth * 0.04, 0),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          deviceWidth * 0.02, 0, deviceWidth * 0.02, 0),
                      child: TextField(
                        controller: startdateinput,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 0)),
                              lastDate: DateTime(2100));

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            setState(() {
                              startdateinput.text = formattedDate.toString();
                            });
                          }
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.02),
                              borderSide: const BorderSide(),
                            ),
                            hintText: "Start Date 📅",
                            hintStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.02),
                            )),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          deviceWidth * 0.02, 0, deviceWidth * 0.02, 0),
                      child: TextField(
                        readOnly: true,
                        controller: enddateinput,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 0)),
                              lastDate: DateTime(2100));

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            setState(() {
                              enddateinput.text = formattedDate.toString();
                            });
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.01),
                            borderSide: const BorderSide(),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.02),
                            borderSide: const BorderSide(),
                          ),
                          hintText: "End Date 📅 ",
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.02),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  deviceWidth * 0.04, 0, deviceWidth * 0.04, 0),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          deviceWidth * 0.02, 0, deviceWidth * 0.02, 0),
                      child: TextField(
                        controller: starttime,
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if (pickedTime != null) {
                            int hour = pickedTime.hour;
                            int minute = pickedTime.minute;
                            setState(() {
                              starttime.text = "$hour:$minute";
                            });
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.01),
                            borderSide: const BorderSide(),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.02),
                            borderSide: const BorderSide(),
                          ),
                          hintText: "Start Time ⏰",
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.02),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          deviceWidth * 0.02, 0, deviceWidth * 0.02, 0),
                      child: TextField(
                        controller: endtime,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                          if (pickedTime != null) {
                            int hour = pickedTime.hour;
                            int minute = pickedTime.minute;
                            setState(() {
                              endtime.text = "$hour:$minute";
                            });
                          }
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.02),
                              borderSide: const BorderSide(),
                            ),
                            hintText: "End Time ⏰",
                            hintStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.02),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  deviceWidth * 0.04, 0, deviceWidth * 0.04, 0),
              child: TextField(
                controller: city,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.01),
                      borderSide: const BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                      borderSide: const BorderSide(),
                    ),
                    hintText: "City",
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                    )),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  deviceWidth * 0.04, 0, deviceWidth * 0.04, 0),
              child: TextField(
                controller: Address,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.01),
                      borderSide: const BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                      borderSide: const BorderSide(),
                    ),
                    hintText: "Address",
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                    )),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.04,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  deviceWidth * 0.04, 0, deviceWidth * 0.04, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(deviceWidth * 0.04)),
              child: DropdownButtonFormField(
                hint: Text(
                  "Registration Closes Before",
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
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.06),
                    )),
                value: RegClosesHrs,
                items: RegCloses.map((value) => DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    )).toList(),
                onChanged: (value) {
                  setState(() {
                    RegClosesHrs = value as String;
                  });
                },
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            SizedBox(
              height: deviceWidth * 0.02,
            ),
            Container(
              width: deviceWidth * 0.8,
              margin: EdgeInsets.fromLTRB(
                  deviceWidth * 0.04, 0, deviceWidth * 0.04, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.06)),
                ),
                onPressed: () {
                  if (EventName.text.isNotEmpty &&
                      startdateinput.text.isNotEmpty &&
                      enddateinput.text.isNotEmpty &
                          starttime.text.isNotEmpty &&
                      endtime.text.isNotEmpty &&
                      city.text.isNotEmpty &&
                      Address.text.isNotEmpty) {
                    print("Cricket pool calling here");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CricketPool(
                          SportName: widget.SportName,
                          EventManagerName: widget.EventManagerName,
                          EventManagerMobileNo: widget.EventManagerMobileNo,
                          EventType: widget.EventType,
                          EventName: EventName.text,
                          StartDate: startdateinput.text,
                          EndDate: enddateinput.text,
                          RegistrationCloses: RegClosesHrs![0],
                          StartTime: starttime.text,
                          EndTime: endtime.text,
                          City: city.text,
                          Address: Address.text,
                          Category: "Cricket",
                          AgeCategory: "Tournament",
                          NoofCourts: "",
                          BreakTime: "",
                          AllCategoryDetails: AllCategories,
                        ),
                      ),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: const Text("Please fill all the fields"),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  }
                },
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
}
