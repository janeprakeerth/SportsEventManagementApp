import 'package:ardent_sports/Model/category_details_model.dart';
import 'package:ardent_sports/features/poll_details/pool_details_data_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Helper/constant.dart';
import '../web_view/web_view_spots.dart';

class PoolDetailsItem extends StatefulWidget {
  final CategorieDetails details;
  final PoolDetailsDataClass pooldata;
  final state = _PoolDetailsItemState();

  PoolDetailsItem({Key? key, required this.details, required this.pooldata})
      : super(key: key);

  @override
  _PoolDetailsItemState createState() => state;
  bool isValid() => state.validate();
}

class _PoolDetailsItemState extends State<PoolDetailsItem> {
  final form = GlobalKey<FormState>();

  List<String> PoolSizes = ['8', '16', '32', '64'];
  List<String> PointSystems = ["21 best of 3", "15 best of 3", "11 best of 3"];

  String? SelectedPointSystem;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 15),
      child: Card(
        elevation: 10,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(deviceWidth * 0.01),
        ),
        margin: EdgeInsets.only(
            left: deviceWidth * 0.025, right: deviceWidth * 0.025),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      deviceWidth * 0.03, deviceWidth * 0.02, 0, 0),
                  child: Text(
                    "${widget.details.AgeCategory} ${widget.details.CategoryName}",
                    style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(deviceWidth * 0.04),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: DropdownButtonFormField(
                  hint: Text(
                    "Pool Size",
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
                      )),
                  // value: widget.pooldata.PoolSize,
                  items: PoolSizes.map((value) => DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      )).toList(),
                  onSaved: (val) => widget.pooldata.PoolSize = val.toString(),
                  onChanged: (value) {
                    setState(() {
                      widget.pooldata.PoolSize = value as String;
                    });
                  },
                ),
              ),
              SizedBox(
                height: deviceWidth * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          deviceWidth * 0.02, 0, deviceWidth * 0.02, 0),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        onSaved: (val) => widget.pooldata.Gold = val.toString(),
                        initialValue: widget.pooldata.Gold,
                        onChanged: (value) {
                          setState(() {
                            widget.pooldata.Gold = value;
                          });
                        },
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
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                            hintText: "Gold",
                            hintStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
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
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        initialValue: widget.pooldata.Silver,
                        onSaved: (val) =>
                            widget.pooldata.Silver = val.toString(),
                        onChanged: (value) {
                          setState(() {
                            widget.pooldata.Silver = value;
                          });
                        },
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
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                            hintText: "Silver",
                            hintStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
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
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        initialValue: widget.pooldata.Bronze,
                        onSaved: (val) =>
                            widget.pooldata.Bronze = val.toString(),
                        onChanged: (value) {
                          setState(() {
                            widget.pooldata.Bronze = value;
                          });
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.04),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.04),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                            hintText: "Bronze",
                            hintStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.02),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(deviceWidth * 0.04),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: widget.pooldata.EntryFee,
                  onSaved: (val) => widget.pooldata.EntryFee = val.toString(),
                  onChanged: (value) {
                    setState(() {
                      widget.pooldata.EntryFee = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      hintText: "Entry Fee",
                      hintStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w200),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                      )),
                ),
              ),
              Container(
                margin: EdgeInsets.all(deviceWidth * 0.04),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: DropdownButtonFormField(
                  hint: Text("Select Point System",
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
                        borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.06),
                      )),
                  // value: SelectedPointSystem,
                  onSaved: (val) =>
                      widget.pooldata.PointSystem = SelectedPointSystem!,
                  items: PointSystems.map((value) => DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      )).toList(),
                  // value: SelectedPointSystem,
                  onChanged: (value) {
                    setState(() {
                      String x = value.toString();
                      SelectedPointSystem = value as String;
                      widget.pooldata.PointSystem = "${x[0]}${x[1]}_${x[11]}";
                      print(x[0]);
                    });
                  },
                ),
              ),
              SizedBox(
                height: deviceWidth * 0.02,
              ),
              Row(),
              Container(
                width: deviceWidth * 0.8,
                margin: EdgeInsets.fromLTRB(
                    deviceWidth * 0.04, 0, deviceWidth * 0.03, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    Get.to(WebViewSpots(spots: widget.pooldata.PoolSize));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(deviceWidth * 0.06)),
                  ),
                  child: const Text(
                    'Preview Fixture',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: deviceWidth * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    form.currentState?.save();
    return true;
  }
}
