import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/live_maintainer_badminton/live_maintainer_badminton.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/authentication/login/login.dart';
import 'features/authentication/login/loginProvider.dart';
import 'features/home_page/home_page.dart';
import 'features/home_page/home_page_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(),
        ),
      ],
      child: GetMaterialApp(
        builder: EasyLoading.init(),
        title: 'Ardent Sports',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        routes: {
          '/': (context) => const login(),
          '/homePage': (context) => const HomePage(),
          '/live': (context) => const LiveMaintainer(
                Tournament_ID: '',
                Match_Id: '',
                Player_1_name: '',
                Player1_Partner: '',
                Player_2_name: '',
                Player2_Partner: '',
                Player1_ID: '',
                Player2_ID: '',
                player1_set_1: 0,
                player1_set_2: 0,
                player1_set_3: 0,
                player2_set_1: 0,
                player2_set_2: 0,
                player2_set_3: 0,
              ),
        },
      ),
    );
  }
}
