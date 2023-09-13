import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'Helper/apis.dart';

class PerMatchEstimatedTimeEditText extends StatefulWidget {
  final String TOURNAMENT_ID;
  const PerMatchEstimatedTimeEditText({Key? key, required this.TOURNAMENT_ID})
      : super(key: key);

  @override
  State<PerMatchEstimatedTimeEditText> createState() =>
      _PerMatchEstimatedTimeEditTextState();
}

class TimeJson {
  late String TOURNAMENT_ID;
  late String PER_MATCH_ESTIMATED_TIME;
  TimeJson(
      {required this.TOURNAMENT_ID, required this.PER_MATCH_ESTIMATED_TIME});
  Map<String, dynamic> toMap() {
    return {
      "TOURNAMENT_ID": this.TOURNAMENT_ID,
      "PER_MATCH_ESTIMATED_TIME": this.PER_MATCH_ESTIMATED_TIME
    };
  }
}

class _PerMatchEstimatedTimeEditTextState
    extends State<PerMatchEstimatedTimeEditText> {
  TextEditingController timevalue = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.5),
      child: SizedBox(
        height: deviceHeight * 0.2,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(deviceWidth * 0.04),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: timevalue,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    hintText: "Enter Time In Minutes",
                    hintStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                    )),
              ),
            ),
            TextButton(
              onPressed: () async {
                final TimeJsonDetails = TimeJson(
                    TOURNAMENT_ID: widget.TOURNAMENT_ID,
                    PER_MATCH_ESTIMATED_TIME: timevalue.text.toString());
                final TimeJsonMap = TimeJsonDetails.toMap();
                final json = jsonEncode(TimeJsonMap);

                var response = await post(updatePerMatchEstimatedTimeApi,
                    headers: {
                      "Accept": "application/json",
                      "Content-Type": "application/json"
                    },
                    body: json,
                    encoding: Encoding.getByName("utf-8"));
                Map<String, dynamic> jsonData = jsonDecode(response.body);
                print(response.statusCode);
                Navigator.pop(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    "Update",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: deviceWidth * 0.033,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
