import 'package:ardent_sports/AgeCategoryItem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../Model/category_details_model.dart';
import '../../Helper/constant.dart';
import '../poll_details/pool_details.dart';

class EventDetails extends StatefulWidget {
  final String? SportName;
  final String EventManagerName;
  final String EventManagerMobileNo;
  final String? EventType;

  const EventDetails({
    Key? key,
    required this.SportName,
    required this.EventManagerName,
    required this.EventManagerMobileNo,
    required this.EventType,
  }) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  List<String> Categories = [
    "Men's Singles",
    "Women's Singles",
    "Men's Doubles",
    "Women's Doubles",
    "Mixed Doubles",
    "Boys Singles",
    "Girls Singles",
    "Boys Doubles",
    "Girls Doubles"
  ];
  late String SelectedCategory;
  Map<Map<String, String>, int> check = {};

  List<String> AgeCategory = [
    'Open',
    'U11',
    'U12',
    'U13',
    'U15',
    'U17',
    'U19',
    'Above 35',
    'Above 40',
    'Above 50',
    'Above 60'
  ];
  List<String> RegCloses = ['6hrs', '12hrs'];
  List<String> NoOfCourts = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
  ];
  late String SelectedAge;
  late String RegClosesHrs;
  late String Courts;

  @override
  TextEditingController EventName = TextEditingController();
  TextEditingController startdateinput = TextEditingController();
  TextEditingController enddateinput = TextEditingController();
  TextEditingController registrationclosedateinput = TextEditingController();
  TextEditingController starttime = TextEditingController();
  TextEditingController endtime = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController Address = TextEditingController();
  // TextEditingController Category = TextEditingController();
  // TextEditingController AgeCategory = TextEditingController();
  TextEditingController noofcourts = TextEditingController();
  TextEditingController breaktime = TextEditingController();

  final DateTime dateStart = DateTime.now().subtract(const Duration(days: 0));
  final DateTime dateEnd = DateTime.now();

  _validate() {
    if (dateEnd.isBefore(dateStart)) {
      Fluttertoast.showToast(msg: "End date should be greater than start date");
    } else {
      DateTime(2100);
    }
  }

  List<AgeCategoryDataClass> _alladdedCategories = [];
  List<Row> AllAddedCategories = [];
  List<CategorieDetails> AllCategories = [];

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
                            // DateTime parsedTime = DateFormat.jm()
                            //     .parse(pickedTime.format(context).toString());
                            // String formattedTime =
                            //     DateFormat('HH:mm:ss').format(parsedTime);
                            // setState(() {
                            //   starttime.text = formattedTime.toString();
                            // });
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
                            )),
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

                            // DateTime parsedTime = DateFormat.jm()
                            //     .parse(pickedTime.format(context).toString());
                            // String formattedTime =
                            //     DateFormat('HH:mm:ss').format(parsedTime);
                            // setState(() {
                            //   endtime.text = formattedTime.toString();
                            // });
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
            Container(
              margin: EdgeInsets.fromLTRB(
                  deviceWidth * 0.03, 0, deviceWidth * 0.03, 0),
              child: Card(
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  children: [
                    SizedBox(
                      height: deviceWidth * 0.04,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          deviceWidth * 0.04, 0, deviceWidth * 0.04, 0),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.04)),
                      child: DropdownButtonFormField(
                        hint: Text("Select Category",
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: deviceWidth * 0.04,
                            )),
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
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.02),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.06),
                            )),
                        // value: SelectedCategory,
                        items: Categories.map((value) => DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            )).toList(),
                        onChanged: (value) {
                          setState(() {
                            SelectedCategory = value as String;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: deviceWidth * 0.02,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          deviceWidth * 0.04, 0, deviceWidth * 0.04, 0),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.04)),
                      child: DropdownButtonFormField(
                        hint: Text("Select Age Category",
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: deviceWidth * 0.04,
                            )),
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
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.02),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.06),
                            )),
                        // value: SelectedAge,
                        items: AgeCategory.map((value) => DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            )).toList(),
                        onChanged: (value) {
                          setState(() {
                            SelectedAge = value as String;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: deviceWidth * 0.02,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.06)),
                      ),
                      onPressed: () {
                        var categoryItem = AgeCategoryDataClass(
                            Category: SelectedCategory,
                            AgeCategory: SelectedAge);
                        bool isCategoryAdded = false;
                        for (AgeCategoryDataClass details
                            in _alladdedCategories) {
                          if (details.Category == categoryItem.Category &&
                              details.AgeCategory == categoryItem.AgeCategory) {
                            isCategoryAdded = true;
                            print("1");
                            break;
                          }
                        }
                        if (!isCategoryAdded) {
                          _addAgeCategoryItem(SelectedCategory, SelectedAge);
                        }
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    for (AgeCategoryDataClass details in _alladdedCategories)
                      AgeCategoryItem(
                        data: details,
                        onDeleteItem: _deleteAgeCategoryItem,
                      )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: deviceWidth * 0.02,
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
                // value: RegClosesHrs,
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
            Container(
              margin: EdgeInsets.fromLTRB(
                  deviceWidth * 0.04, 0, deviceWidth * 0.04, 0),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          deviceWidth * 0.02, 0, deviceWidth * 0.02, 0),
                      child: DropdownButtonFormField(
                        hint: Text("No of courts",
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: deviceWidth * 0.04,
                            )),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.red,
                        ),
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
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.02),
                            )),
                        // value: Courts,
                        items: NoOfCourts.map((value) => DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            )).toList(),
                        onChanged: (value) {
                          setState(() {
                            Courts = value as String;
                          });
                        },
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
                      enddateinput.text.isNotEmpty &&
                      RegClosesHrs != Null &&
                      starttime.text.isNotEmpty &&
                      endtime.text.isNotEmpty &&
                      city.text.isNotEmpty &&
                      Address.text.isNotEmpty &&
                      SelectedAge.toString().isNotEmpty &&
                      SelectedCategory.toString().isNotEmpty &&
                      Courts != Null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PoolDetails(
                          SportName: widget.SportName,
                          EventManagerName: widget.EventManagerName,
                          EventManagerMobileNo: widget.EventManagerMobileNo,
                          EventType: widget.EventType,
                          EventName: EventName.text,
                          StartDate: startdateinput.text,
                          EndDate: enddateinput.text,
                          RegistrationCloses: RegClosesHrs[0],
                          StartTime: starttime.text,
                          EndTime: endtime.text,
                          City: city.text,
                          Address: Address.text,
                          Category: SelectedCategory,
                          AgeCategory: SelectedAge,
                          NoofCourts: Courts,
                          BreakTime: breaktime.text,
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

  void _addAgeCategoryItem(String Category, String AgeCatogery) {
    setState(() {
      _alladdedCategories.add(AgeCategoryDataClass(
        Category: Category,
        AgeCategory: AgeCatogery,
      ));
      AllCategories.add(CategorieDetails(Category, AgeCatogery));
    });
  }

  void _deleteAgeCategoryItem(String Category, String AgeCatogery) {
    setState(() {
      _alladdedCategories.removeWhere((item) =>
          item.Category == Category && item.AgeCategory == AgeCatogery);
      AllCategories.removeWhere((element) =>
          element.CategoryName == Category &&
          element.AgeCategory == AgeCatogery);
    });
  }
}
