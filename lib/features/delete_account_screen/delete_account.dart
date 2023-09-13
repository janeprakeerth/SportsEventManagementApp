import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helper/apis.dart';
import '../../Helper/constant.dart';
import '../../UserDetails.dart';
import '../authentication/login/login.dart';
import '../../Helper/set_snackbar.dart';
import '../home_page/home_page.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  double cardheight = 0;
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    cardheight = deviceHeight * 0.55;
    return Scaffold(
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
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (a, b, c) => const HomePage()));
                },
                child: const Image(
                  alignment: Alignment.center,
                  image: AssetImage('assets/AARDENT.png'),
                ),
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
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Text(
                  'Are you sure you want to delete account?',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Your all return tournaments request, ongoing tournaments, score board and also your all data will be deleted. So you will not able to access this account further. We understand if you want you can create new account to use this application.',
                  style: TextStyle(
                    fontSize: 16,
                    textBaseline: TextBaseline.ideographic,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(deviceWidth * 0.04,
                    deviceWidth * 0.08, deviceWidth * 0.04, 0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(deviceWidth * 0.08)),
                    hintText: 'Enter Your Password',
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
                    "Delete Now",
                    style: TextStyle(fontSize: deviceWidth * 0.05),
                  ),
                  onPressed: () async {
                    final waitList = <Future<void>>[];
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var email = await prefs.getString('email');
                    // print('email : ')
                    if (password.text.trim().isNotEmpty) {
                      final logindetails = LoginDetails(
                        EmailId: email.toString(),
                        Password: password.text.toString().trim(),
                      );
                      final logindetailsmap = logindetails.toMap();
                      final json = jsonEncode(logindetailsmap);
                      var response = await post(
                        getUserLoginApi,
                        headers: {
                          "Accept": "application/json",
                          "Content-Type": "application/json"
                        },
                        body: json,
                        encoding: Encoding.getByName("utf-8"),
                      );
                      final jsonResponse = jsonDecode(response.body);

                      if (jsonResponse['Message'] == "USER Verified") {
                        var parameter = {
                          'USERID': email,
                        };
                        var data = await post(removeUserApi,
                            headers: {
                              "Accept": "application/json",
                              "Content-Type": "application/json"
                            },
                            body: jsonEncode(parameter),
                            encoding: Encoding.getByName("utf-8"));
                        print('response : ${response.body.toString()}');

                        final responseDeleteUser = jsonDecode(data.body);
                        if (responseDeleteUser['Message'].toString() ==
                            "USER Deleted") {
                          waitList.add(prefs.remove('email'));
                          await prefs.clear();
                          setSnackbar("USER Deleted", context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const login(),
                            ),
                          );
                        } else {
                          setSnackbar("Something wrong happens", context);
                        }
                      } else {
                        setSnackbar("Incorrect Password", context);
                      }
                    }
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
