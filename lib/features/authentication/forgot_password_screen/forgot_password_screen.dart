import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import '../../../helper/apis.dart';
import '../../../helper/constant.dart';
import '../../../helper/set_snackbar.dart';
import '../../home_page/home_page.dart';
import '../verify_otp/verify_otp.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({Key? key}) : super(key: key);

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  double cardheight = 0;
  final emaild = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    cardheight = deviceHeight * 0.40;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: deviceHeight * 0.1,
              ),
              InkWell(
                onTap: () {},
                child: const Image(
                  alignment: Alignment.center,
                  image: AssetImage('assets/AARDENT.png'),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.1,
              ),
              loginFields(context),
            ],
          ),
        ),
      ),
    );
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const Text(
                  'Enter your email address we will send 6 digits code to your email.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
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
                    "Send OTP",
                    style: TextStyle(fontSize: deviceWidth * 0.05),
                  ),
                  onPressed: () async {
                    EasyLoading.show(
                        status: 'Loading...',
                        indicator: const SpinKitThreeBounce(
                          color: Color(0xFFE74545),
                        ),
                        maskType: EasyLoadingMaskType.black);
                    if (emaild.text.trim().isNotEmpty) {
                      var parameter = {
                        'USERID': emaild.text.toString(),
                      };
                      print('parameter : $parameter');
                      final json = jsonEncode(parameter);
                      var response = await post(resetpwdOtpgenApi,
                          headers: {
                            "Accept": "application/json",
                            "Content-Type": "application/json"
                          },
                          body: json,
                          encoding: Encoding.getByName("utf-8"));
                      final jsonResponse = jsonDecode(response.body);
                      print('response : ${jsonResponse}');
                      if (jsonResponse['Message'] == "Success") {
                        EasyLoading.dismiss();
                        setSnackbar("OTP Send Successfully", context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyOTP(
                              email: emaild.text.toString(),
                              fromSingUpVerification: false,
                            ),
                          ),
                        );
                        EasyLoading.dismiss();
                      } else {
                        const msg = "Something Wrong!!!";
                        setSnackbar(msg, context);
                        EasyLoading.dismiss();
                      }
                    }
                    EasyLoading.dismiss();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
