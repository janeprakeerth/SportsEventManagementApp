import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../Helper/apis.dart';
import '../../../Helper/constant.dart';
import '../../../Helper/set_snackbar.dart';
import '../../home_page/home_page.dart';
import '../sign_up_page.dart';
import '../change_password/change_password.dart';

class VerifyOTP extends StatefulWidget {
  String email;
  bool fromSingUpVerification;
  String? password;
  String? mobile;
  VerifyOTP({
    Key? key,
    required this.email,
    required this.fromSingUpVerification,
    this.mobile,
    this.password,
  }) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  String? otp;
  double cardheight = 0;
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Please Enter your 6 digits OTP code here.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              otpLayout(),
              const SizedBox(
                height: 20,
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
                    "Verify OTP",
                    style: TextStyle(fontSize: deviceWidth * 0.05),
                  ),
                  onPressed: () async {
                    EasyLoading.show(
                        status: 'Loading...',
                        indicator: const SpinKitThreeBounce(
                          color: Color(0xFFE74545),
                        ),
                        maskType: EasyLoadingMaskType.black);
                    if (widget.email.isNotEmpty) {
                      var parameter = {
                        'USERID': widget.email.toString(),
                        'OTP': otp,
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
                        setSnackbar("OTP Verify Successfully", context);
                        if (widget.fromSingUpVerification) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubmitPage(
                                email: widget.email,
                                password: widget.password!,
                                fromGoogleSingIn: false,
                                showMobileNumber: false,
                                mobile: widget.mobile!,
                              ),
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePassword(
                                email: widget.email,
                              ),
                            ),
                          );
                        }
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

  otpLayout() {
    return Padding(
      padding: const EdgeInsetsDirectional.all(8),
      child: PinFieldAutoFill(
        decoration: BoxLooseDecoration(
          textStyle: const TextStyle(fontSize: 20, color: Colors.grey),
          radius: const Radius.circular(5),
          gapSpace: 15,
          bgColorBuilder: FixedColorBuilder(Colors.grey.withOpacity(0.4)),
          strokeColorBuilder: FixedColorBuilder(
            Colors.blue.withOpacity(0.2),
          ),
        ),
        enabled: true,
        currentCode: otp,
        codeLength: 6,
        onCodeChanged: (String? code) {
          otp = code;
        },
        onCodeSubmitted: (String code) {
          otp = code;
        },
      ),
    );
  }
}
