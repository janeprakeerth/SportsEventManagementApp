import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helper/constant.dart';
import '../../ScoreAChallenge.dart';
import '../create_competition/create_challenge.dart';
import '../delete_account_screen/delete_account.dart';
import '../home_page/home_page.dart';
import '../hosted_challenges/hosted_challenges.dart';
import '../my_bookings/my_bookings.dart';

class Menu extends StatefulWidget {
  final String? name;
  const Menu({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Homepage.png"), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (a, b, c) => const HomePage()));
                },
                child: Container(
                  width: deviceWidth * 0.4,
                  height: deviceWidth * 0.4,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/AARDENT.png"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(
                height: deviceWidth * 0.06,
              ),
              SizedBox(
                height: deviceWidth * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: deviceWidth * 0.08,
                    height: deviceWidth * 0.08,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/plus.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateChallenge()));
                    },
                    child: const Text(
                      "Create Challenge",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: deviceWidth * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: deviceWidth * 0.08,
                    height: deviceWidth * 0.08,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/score 1.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScoreAChallenge(
                            name: widget.name,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Score a challenge",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: deviceWidth * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: deviceWidth * 0.06,
                    height: deviceWidth * 0.06,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/Vector.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyBookings(),
                        ),
                      );

                      // Get.to(const MyBookings());
                    },
                    child: const Text(
                      "My Bookings",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: deviceWidth * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: deviceWidth * 0.08,
                    height: deviceWidth * 0.08,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/Vecto1.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(HostedChallenges());
                      },
                      child: const Text(
                        "My Hosted Challenges",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              SizedBox(
                height: deviceWidth * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete),
                  TextButton(
                      onPressed: () {
                        Get.to(const DeleteAccount());
                      },
                      child: const Text(
                        "Delete Account",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              SizedBox(
                height: deviceWidth * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: deviceWidth * 0.08,
                    height: deviceWidth * 0.08,
                  ),
                  const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Logout Alert"),
                          content:
                              const Text("Are you sure you want to Logout?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                child: const Text(
                                  "NO",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('email');

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/', (Route<dynamic> route) => false);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                child: const Text("YES",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
