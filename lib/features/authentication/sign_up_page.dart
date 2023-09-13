import 'dart:convert';
import 'package:ardent_sports/UserDetails.dart';
import 'package:ardent_sports/features/authentication/verify_otp/verify_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helper/apis.dart';
import '../../Helper/constant.dart';
import '../home_page/home_page.dart';
import 'verify_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPage createState() => _SignUpPage();
}

TextEditingController passController = TextEditingController();
TextEditingController repassController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController mobileController = TextEditingController();

class _SignUpPage extends State<SignUpPage> {
  bool isChecked = false;

  @override
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
                image: AssetImage('assets/login.png'), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: const Image(
                    alignment: Alignment.center,
                    image: AssetImage('assets/AARDENT.png'),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Card(
                  margin: EdgeInsets.only(
                      left: deviceWidth * 0.05, right: deviceWidth * 0.05),
                  color: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.04)),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: deviceWidth * 0.03,
                        right: deviceWidth * 0.03,
                        top: deviceWidth * 0.05,
                        bottom: deviceWidth * 0.05),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.06),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.06),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.06),
                              )),
                        ),
                        SizedBox(
                          height: deviceWidth * 0.06,
                        ),
                        TextField(
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.06),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.06),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "MobileNo",
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.06),
                              )),
                        ),
                        SizedBox(
                          height: deviceWidth * 0.06,
                        ),
                        TextField(
                          controller: passController,
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.06),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.06),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.06),
                              )),
                        ),
                        SizedBox(
                          height: deviceWidth * 0.06,
                        ),
                        TextField(
                          controller: repassController,
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.06),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.06),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.06),
                              )),
                        ),
                        SizedBox(
                          height: deviceWidth * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              side: const BorderSide(color: Colors.red),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            Text(
                              'Accept Terms & Conditions',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: deviceWidth * 0.045,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ButtonTheme(
                              height: deviceWidth * 0.1,
                              minWidth: deviceWidth * 0.4,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (emailController.text.trim().isNotEmpty &&
                                      mobileController.text.trim().isNotEmpty &&
                                      passController.text.trim().isNotEmpty &&
                                      repassController.text.trim().isNotEmpty) {
                                    if (passController.text.toString().trim() ==
                                        repassController.text
                                            .toString()
                                            .trim()) {
                                      try {
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                          email: emailController.text.trim(),
                                          password: passController.text.trim(),
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => VerifyPage(
                                              email:
                                                  emailController.text.trim(),
                                              password:
                                                  passController.text.trim(),
                                              mobile:
                                                  mobileController.text.trim(),
                                            ),
                                          ),
                                        );
                                      } on FirebaseAuthException catch (exception) {
                                        print(' e : $exception');
                                        if (exception.toString() ==
                                            "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
                                          EasyLoading.show(
                                              status: 'Loading...',
                                              indicator:
                                                  const SpinKitThreeBounce(
                                                color: Color(0xFFE74545),
                                              ),
                                              maskType:
                                                  EasyLoadingMaskType.black);
                                          var parameter = {
                                            'USERID':
                                                emailController.text.toString(),
                                          };
                                          print('parameter : $parameter');
                                          final json = jsonEncode(parameter);
                                          var response = await post(
                                              resetpwdOtpgenApi,
                                              headers: {
                                                "Accept": "application/json",
                                                "Content-Type":
                                                    "application/json",
                                              },
                                              body: json,
                                              encoding:
                                                  Encoding.getByName("utf-8"));
                                          final jsonResponse =
                                              jsonDecode(response.body);
                                          print('response : ${jsonResponse}');
                                          if (jsonResponse['Message'] ==
                                              "Success") {
                                            Fluttertoast.showToast(
                                                msg: "OTP Send Successfully",
                                                toastLength:
                                                    Toast.LENGTH_SHORT);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => VerifyOTP(
                                                  email: emailController.text,
                                                  fromSingUpVerification: true,
                                                  mobile: mobileController.text
                                                      .trim(),
                                                  password: passController.text
                                                      .trim(),
                                                ),
                                              ),
                                            );
                                            EasyLoading.dismiss();
                                          } else {
                                            const msg = "Something Wrong!!!";
                                            Fluttertoast.showToast(
                                                msg: msg,
                                                toastLength:
                                                    Toast.LENGTH_SHORT);
                                            EasyLoading.dismiss();
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: exception.toString(),
                                              toastLength: Toast.LENGTH_SHORT);
                                        }
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Password and Confirm Password must be same"),
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("All fields must be entered"),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffE74545),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      deviceWidth * 0.06,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Log In >",
                      style: TextStyle(
                        color: Color(0xffE74545),
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    )),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubmitPage extends StatefulWidget {
  String email;
  String password;
  String mobile;
  bool fromGoogleSingIn;
  bool showMobileNumber;

  SubmitPage({
    Key? key,
    required this.email,
    required this.password,
    required this.fromGoogleSingIn,
    required this.mobile,
    required this.showMobileNumber,
  }) : super(key: key);

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final first_name = TextEditingController();
  final last_name = TextEditingController();
  final passwordController = TextEditingController();
  final mobileController = TextEditingController();
  final date_of_birth = TextEditingController();

  final state = TextEditingController();

  final city = TextEditingController();

  final Academy = TextEditingController();

  final Intersted_Sports = TextEditingController();

  List<String> gender = ['Male', 'Female', 'Other', 'Prefer not to respond'];

  String? selectedGender;

  @override
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
              image: AssetImage("assets/login.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.only(
                        left: deviceWidth * 0.05,
                        right: deviceWidth * 0.05,
                        top: deviceWidth * 0.2,
                        bottom: 0),
                    color: Colors.white.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(deviceWidth * 0.04)),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(deviceWidth * 0.06,
                                deviceWidth * 0.02, deviceWidth * 0.06, 0),
                            child: Row(
                              children: [
                                Center(
                                  child: Image.asset(
                                      "assets/profile-avatar 1.png"),
                                ),
                                const Center(
                                  child: Text(
                                    "Set Up Your Profile",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(deviceWidth * 0.04,
                                deviceWidth * 0.02, deviceWidth * 0.04, 0),
                            child: SizedBox(
                              height: deviceWidth * 0.14,
                              child: TextFormField(
                                controller: first_name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.06)),
                                  hintText: '  First name',
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceWidth * 0.06),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(deviceWidth * 0.04,
                                deviceWidth * 0.02, deviceWidth * 0.04, 0),
                            child: SizedBox(
                              height: deviceWidth * 0.14,
                              child: TextFormField(
                                controller: last_name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.06)),
                                  hintText: '  Last Name',
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceWidth * 0.06),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        widget.fromGoogleSingIn
                            ? Center(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      deviceWidth * 0.04,
                                      deviceWidth * 0.02,
                                      deviceWidth * 0.04,
                                      0),
                                  child: SizedBox(
                                    height: deviceWidth * 0.14,
                                    child: TextFormField(
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                deviceWidth * 0.06)),
                                        hintText: '  Password',
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceWidth * 0.06),
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        widget.showMobileNumber
                            ? Center(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      deviceWidth * 0.04,
                                      deviceWidth * 0.02,
                                      deviceWidth * 0.04,
                                      0),
                                  child: SizedBox(
                                    height: deviceWidth * 0.14,
                                    child: TextFormField(
                                      controller: mobileController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                deviceWidth * 0.06)),
                                        hintText: '  Mobile Number',
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceWidth * 0.06),
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Center(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(deviceWidth * 0.04,
                                deviceWidth * 0.02, deviceWidth * 0.04, 0),
                            child: SizedBox(
                              height: deviceWidth * 0.14,
                              child: TextFormField(
                                controller: date_of_birth,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                    setState(() {
                                      date_of_birth.text =
                                          formattedDate.toString();
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.06)),
                                  hintText: '  Date of Birth (dd-mm-yy)',
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceWidth * 0.06),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(deviceWidth * 0.04,
                                deviceWidth * 0.02, deviceWidth * 0.04, 0),
                            child: SizedBox(
                              height: deviceWidth * 0.14,
                              child: TextFormField(
                                controller: state,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.06)),
                                  hintText: '  State',
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceWidth * 0.06),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(deviceWidth * 0.04,
                                deviceWidth * 0.02, deviceWidth * 0.04, 0),
                            child: SizedBox(
                              height: deviceWidth * 0.14,
                              child: TextFormField(
                                controller: city,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.06)),
                                  hintText: '  City',
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceWidth * 0.06),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(deviceWidth * 0.04,
                                deviceWidth * 0.02, deviceWidth * 0.04, 0),
                            child: SizedBox(
                              height: deviceWidth * 0.16,
                              child: DropdownButtonFormField(
                                value: selectedGender,
                                items: gender
                                    .map((value) => DropdownMenuItem(
                                          child: Text(value),
                                          value: value,
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value as String;
                                  });
                                },
                                hint: Text("Select Gender",
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
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.06)),
                                  hintText: '  Gender',
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceWidth * 0.06),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, deviceWidth * 0.05, 0, 0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          print(
                              'widget.email.toString(), : ${widget.email.toString()}');
                          if (first_name.text.trim().isNotEmpty &&
                              last_name.text.trim().isNotEmpty &&
                              date_of_birth.text.isNotEmpty &&
                              state.text.isNotEmpty &&
                              city.text.isNotEmpty &&
                              selectedGender!.isNotEmpty) {
                            final Details = UserDetails(
                                USERID: widget.email.toString(),
                                PHONE: widget.showMobileNumber
                                    ? mobileController.text.toString()
                                    : widget.mobile.toString(),
                                NAME: first_name.text.toString(),
                                EMAIL: widget.email.toString(),
                                PWD: widget.fromGoogleSingIn
                                    ? passwordController.text.toString()
                                    : widget.password.toString(),
                                GENDER: selectedGender as String,
                                DOB: date_of_birth.text.toString(),
                                CITY: city.text.toString(),
                                STATE: state.text.toString(),
                                SPORTS_ACADEMY: "NULL",
                                PROFILE_ID: widget.email.toString(),
                                INTERESTED_SPORTS: "NULL");
                            final DetailMap = Details.toMap();
                            final json = jsonEncode(DetailMap);
                            var response = await post(createUserApi,
                                headers: {
                                  "Accept": "application/json",
                                  "Content-Type": "application/json"
                                },
                                body: json,
                                encoding: Encoding.getByName("utf-8"));
                            print(
                                'submit page response : ${response.body.toString()}');
                            final jsonResponse = jsonDecode(response.body);
                            if (jsonResponse['Message'] == "User Exists") {
                              // final SharedPreferences prefs =
                              //     await SharedPreferences.getInstance();
                              // var obtianedEmail = prefs.setString(
                              //     'email', emailController.text);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Email Already Exists,please try with different email"),
                              ));
                            } else {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var obtianedEmail = prefs.setString(
                                  'email', emailController.text);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Successfully Registered"),
                              ));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("All Fields Must Be Filled"),
                            ));
                          }
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffE74545),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.06)),
                        ),
                      ),
                    ),
                  ),
                  Container(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
