import 'dart:async';
import 'package:ardent_sports/features/authentication/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyPage extends StatefulWidget {
  final String email;
  final String password;
  final String mobile;
  const VerifyPage({
    required this.email,
    required this.password,
    required this.mobile,
    Key? key,
  }) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        checkEmailVerified();
      });
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState((() => canResendEmail = true));
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(), toastLength: Toast.LENGTH_SHORT);
    }
  }

  Future checkEmailVerified() async {
    var user = await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? SubmitPage(
          email: widget.email,
          password: widget.password,
          fromGoogleSingIn: false,
          showMobileNumber: false,
          mobile: widget.mobile,
        )
      : Scaffold(
          appBar: AppBar(
            title: const Text("Verify Email"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'A verification email has been sent to your ${widget.email}.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(
                    Icons.email,
                    size: 32,
                  ),
                  label: const Text(
                    'Resent Email',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
                const SizedBox(height: 8),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                )
              ],
            ),
          ),
        );
}
