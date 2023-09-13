import 'dart:async';
import 'dart:convert';
import 'package:ardent_sports/Helper/set_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import '../../../Helper/apis.dart';
import '../../../Helper/constant.dart';
import '../../home_page/home_page.dart';
import '../forgot_password_screen/forgot_password_screen.dart';
import '../sign_up_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../UserDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../google_sign_in/google_sing_in.dart';

String? finalEmail;
late Socket socket;

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  Future getValidationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var obtianedEmail = prefs.getString('email');
    setState(() {
      finalEmail = obtianedEmail;
    });
    debugPrint("Email: $finalEmail");
  }

  @override
  void initState() {
    super.initState();
    getValidationData().whenComplete(() async {
      if (finalEmail == null) {
        Get.to(const login());
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });
  }

  double cardheight = 0;
  final emaild = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    cardheight = deviceHeight * 0.47;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: deviceWidth,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/login.png"), fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: InkWell(
                        onTap: () {}, child: Image.asset("assets/AARDENT.png")),
                  ),
                  loginFields(context),
                  singUP_button(context),
                  googleSingInMethod(context),
                  // by onpressed we call the function signup function
                  termCondition(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container termCondition() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white.withOpacity(0.5),
            textStyle: const TextStyle(
              fontSize: 15,
            ),
          ),
          onPressed: () {},
          child: const Text('Terms & Conditions'),
        ),
      ),
    );
  }

  Padding googleSingInMethod(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      child: InkWell(
        onTap: () {
          print("press material button ");
          Authentication.signInWithGoogle(context: context).then(
            (value) async {
              if (value == null) {
                // nothing happen
              } else {
                print('value : ${value}');
                EasyLoading.show(
                    status: 'Loading...',
                    indicator: const SpinKitThreeBounce(
                      color: Color(0xFFE74545),
                    ),
                    maskType: EasyLoadingMaskType.black);
                var parameter = {
                  'USERID': value.email,
                };
                if (value.emailVerified) {
                  // user exist or not .
                  final json = jsonEncode(parameter);
                  print("findUserByIDApi : $findUserByIDApi, json : $json");
                  var response = await post(findUserByIDApi,
                      headers: {
                        "Accept": "application/json",
                        "Content-Type": "application/json"
                      },
                      body: json,
                      encoding: Encoding.getByName("utf-8"));
                  final jsonResponse = jsonDecode(response.body);
                  if (jsonResponse['EMAIL'] == value.email) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('email', value.email!);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Logged in successfully"),
                      ),
                    );
                  }
                  if (jsonResponse['Message'] == 'Failure') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubmitPage(
                          email: value.email ?? '',
                          password: '',
                          fromGoogleSingIn: true,
                          mobile: '',
                          showMobileNumber: true,
                        ),
                      ),
                    );
                  }
                }
                EasyLoading.dismiss();
                Authentication.signOut(context: context);
              }
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30.0,
                width: 30.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/googlepng.jpeg'),
                      fit: BoxFit.cover),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                "Sign In with Google",
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center singUP_button(BuildContext context) {
    return Center(
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xffE74545),
          textStyle: const TextStyle(
            fontSize: 15,
          ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  child: const SignUpPage()));
        },
        child: const Text('Sign Up >'),
      ),
    );
  }

  Future<bool> forGoogleSingIn() async {
    var user = await FirebaseAuth.instance.currentUser!.reload();

    setState(() {});
    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  Future<bool> checkEmailVerified() async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emaild.text, password: password.text)
          .then((value) {
        setState(() {});
        return true;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setSnackbar('No user found for that email.', context);
        return false;
      } else if (e.code == 'wrong-password') {
        setSnackbar('Wrong password provided for that user.', context);
        return false;
      }
    }
    return false;
  }

  Center loginFields(BuildContext context) {
    return Center(
      child: Container(
        height: cardheight,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        padding: EdgeInsets.fromLTRB(
            deviceWidth * 0.04, 0, deviceWidth * 0.04, deviceWidth * 0.04),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white.withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(deviceWidth * 0.04,
                    deviceWidth * 0.08, deviceWidth * 0.04, 0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emaild,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(deviceWidth * 0.08)),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.06),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(deviceWidth * 0.04,
                    deviceWidth * 0.04, deviceWidth * 0.04, 0),
                child: TextField(
                  obscureText: true,
                  controller: password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(deviceWidth * 0.08)),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.06),
                    ),
                  ),
                ),
              ),
              Container(
                width: deviceWidth * 0.4,
                margin: EdgeInsets.fromLTRB(
                    deviceWidth * 0.04, 0.07 * cardheight, 0, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(deviceWidth * 0.03),
                    backgroundColor: const Color(0xffE74545),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: deviceWidth * 0.05),
                  ),
                  onPressed: () async {
                    EasyLoading.show(
                        status: 'Loading...',
                        indicator: const SpinKitThreeBounce(
                          color: Color(0xFFE74545),
                        ),
                        maskType: EasyLoadingMaskType.black);

                    if (emaild.text.trim().isNotEmpty ||
                        password.text.trim().isNotEmpty) {
                      final logindetails = LoginDetails(
                          EmailId: emaild.text.toString().trim(),
                          Password: password.text.toString().trim());
                      final logindetailsmap = logindetails.toMap();
                      final json = jsonEncode(logindetailsmap);
                      var response = await post(getUserLoginApi,
                          headers: {
                            "Accept": "application/json",
                            "Content-Type": "application/json"
                          },
                          body: json,
                          encoding: Encoding.getByName("utf-8"));
                      final jsonResponse = jsonDecode(response.body);
                      print('response : ${jsonResponse}');
                      if (jsonResponse['Message'] == "USER Verified") {
                        EasyLoading.dismiss();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                        setSnackbar("Logged in successfully", context);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('email', emaild.text);
                        EasyLoading.dismiss();
                      } else if (jsonResponse['Message'] == 'Incorrect Pwd') {
                        const msg = "Incorrect Password";
                        setSnackbar(msg, context);
                        // Fluttertoast.showToast(msg: msg);
                        EasyLoading.dismiss();
                      } else if (jsonResponse['Message'] == "Invalid USERID") {
                        const msg = "Invalid UserID";
                        setSnackbar(msg, context);
                        // Fluttertoast.showToast(msg: msg);
                        EasyLoading.dismiss();
                      }
                    }
                    EasyLoading.dismiss();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0.05 * cardheight, 0, 0),
                child: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const forgotPassword(),
                        ),
                      );
                    },
                    child: const Text('Forgot Password ?'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
