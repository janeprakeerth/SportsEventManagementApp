// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helper/constant.dart';
import '../web_view/web_view_trophies.dart';

class Profile extends StatefulWidget {
  final String? name;
  final String? points;
  final String? pointsScored;
  final String? totalPoints;
  final String? level;
  final String? totalTourney;
  final String? tourneyWon;
  final String? email;
  const Profile({
    Key? key,
    required this.name,
    required this.points,
    required this.pointsScored,
    required this.totalPoints,
    required this.level,
    required this.totalTourney,
    required this.tourneyWon,
    required this.email,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? image;

  Dio dio = Dio();

  bool isLoading = false;
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                pickImage(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                pickImage(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    var imagePicker = await ImagePicker().pickImage(
        source: source, imageQuality: 50, maxHeight: 1080, maxWidth: 1080);

    if (imagePicker != null) {
      setState(() {
        image = File(imagePicker.path);
      });

      uploadImage();
      Navigator.of(context).pop();
    }
  }

  Map? mapUserImage;
  bool isLoaded = false;

  Future getImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString('email');
    var url =
        'http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/profilePicUrl?USERID=$userName';

    try {
      Response response;
      response = await dio.get(url);

      if (response.statusCode == 200) {
        setState(() {
          isLoaded = true;
          mapUserImage = response.data;
          print(mapUserImage?['Message']);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      isLoaded = false;
    }
  }

  Future uploadImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var userName = prefs.getString('email');
      String filename = image!.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(image!.path,
            filename: filename, contentType: MediaType('image', 'jpg')),
        "type": "image/jpg",
        "USERID": userName
      });

      Response response = await dio.post(
        'http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/postProfilePic',
        data: formData,
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          mapUserImage = response.data;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      EasyLoading.showError("Error uploading image");
    }
  }

  @override
  void initState() {
    getImage();
    super.initState();
  }

  Future refreshProfile() async {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (a, b, c) => Profile(
                  name: widget.name,
                  points: widget.points,
                  pointsScored: widget.pointsScored,
                  totalPoints: widget.totalPoints,
                  level: widget.level,
                  totalTourney: widget.totalTourney,
                  tourneyWon: widget.tourneyWon,
                  email: widget.email,
                )));
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    double progress = double.parse(widget.points!);

    Widget buildLinearProgress() => Text(
          '${(progress * 100).toStringAsFixed(0)}/${widget.totalPoints}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        );

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: SafeArea(
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: refreshProfile,
            child: Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // color: Colors.black,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/background_rect.png'),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.all(Radius.circular(
                            MediaQuery.of(context).size.height * 0.03)),
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.height *
                                            0.0188),
                                    child: Stack(
                                      children: [
                                        isLoaded == false
                                            ? CircularProgressIndicator()
                                            : CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.145, // Image radius
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        mapUserImage?[
                                                                    'Message'] ==
                                                                'No Image'
                                                            ? 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'
                                                            : mapUserImage?[
                                                                'Message'])),
                                        Positioned(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.045,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: ((builder) =>
                                                    bottomSheet()),
                                              );
                                            },
                                            child: Icon(
                                              Icons.camera_alt,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "${widget.name}",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "${widget.email}",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                            child: Text(
                                          "Play Bold BE Ardent",
                                          style: GoogleFonts.hennyPenny(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                        )
                                            //knewave
                                            //henny penny
                                            //leckerliOne

                                            ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF000000).withOpacity(0.4),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          MediaQuery.of(context).size.height *
                                              0.03)),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Your Experience",
                                            hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: ElevatedButton(
                                          // + button logic here............
                                          onPressed: () {},
                                          child: Icon(
                                            Icons.add,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.16,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/GreenRect.png',
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "Level:${widget.level}",
                                style: GoogleFonts.hennyPenny(fontSize: 22),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0)),
                                                child: LinearProgressIndicator(
                                                  value: progress,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 55, 54, 54),
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.green),
                                                ),
                                              ),
                                              Center(
                                                  child: buildLinearProgress())
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          MediaQuery.of(context).size.height *
                                              0.03)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewTrophie(
                                      userId: widget.email,
                                    )));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              'assets/OrangeRect.png',
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  "The Trophy Room",
                                  style: GoogleFonts.hennyPenny(fontSize: 22),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/GoldTrophy.png')),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.02)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            MediaQuery.of(context).size.height *
                                                0.03)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.16,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.028),
                          color: Colors.pinkAccent),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                                margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        0.00),
                                child: Text(
                                  "Analytics",
                                  style: GoogleFonts.hennyPenny(fontSize: 22),
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: deviceWidth * 0.25,
                                height: deviceWidth * 0.23,
                                margin:
                                    EdgeInsets.only(left: deviceWidth * 0.028),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(deviceWidth * 0.014),
                                    ),
                                    color: Colors.black.withOpacity(0.6)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: deviceWidth * 0.028),
                                      child: Text(
                                        "Points",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: deviceWidth * 0.028),
                                      child: Text(
                                        widget.pointsScored.toString(),
                                        style: GoogleFonts.hennyPenny(
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: deviceWidth * 0.25,
                                height: deviceWidth * 0.23,
                                margin:
                                    EdgeInsets.only(left: deviceWidth * 0.028),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(deviceWidth * 0.014),
                                    ),
                                    color: Colors.black.withOpacity(0.6)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: deviceWidth * 0.028),
                                      child: Column(
                                        children: const [
                                          Text(
                                            "Tournaments",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            "Won",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: deviceWidth * 0.028),
                                      child: Text(
                                        widget.tourneyWon.toString(),
                                        style: GoogleFonts.hennyPenny(
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: deviceWidth * 0.25,
                                height: deviceWidth * 0.23,
                                margin:
                                    EdgeInsets.only(left: deviceWidth * 0.028),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(deviceWidth * 0.014),
                                    ),
                                    color: Colors.black.withOpacity(0.6)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: deviceWidth * 0.028),
                                      child: Column(
                                        children: const [
                                          Text(
                                            "Tournaments",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            "Played",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: deviceWidth * 0.028),
                                      child: Text(
                                        widget.totalTourney.toString(),
                                        style: GoogleFonts.hennyPenny(
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
