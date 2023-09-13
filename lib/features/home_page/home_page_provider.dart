import 'dart:convert';
import 'package:ardent_sports/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helper/apis.dart';
import '../home_page/widget/get_tournaments.dart';

class HomeProvider extends ChangeNotifier {
  // for version of android and ios
  String? androidVersion = '1.0.0';
  String? iOSVersion = '1.0.0';
  List<Card> AllTournaments = [];
  Map? mapUserInfo;
  dynamic email;

  initializeVariables() {
    androidVersion = '1.0.0';
    iOSVersion = '1.0.0';
    AllTournaments = [];
    mapUserInfo = null;
    email = null;
  }

  getAllTournaments(BuildContext context) async {
    var response = await get(
      baseTournamentsApi,
    );
    print('$baseTournamentsApi response : ${response.body.toString()}');
    List<dynamic> jsonData = jsonDecode(response.body);
    try {
      List<UserData> userdata =
          jsonData.map((dynamic item) => UserData.fromJson(item)).toList();
      int array_length = userdata.length;
      print(userdata);
      return getTournaments(userdata, array_length, context);
    } catch (e) {
      print('excwption :: $e');
    }
  }

  Future getDetails(Function update) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    final uri =
        'http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/userDetails?USERID=${email!.trim()}';

    var response;
    response = await get(Uri.parse(uri));

    if (response.statusCode == 200) {
      mapUserInfo = json.decode(response.body);
      print("mapUserInfo  : $mapUserInfo");
      update();
    }
  }

  Future getVersions() async {
    final uri = 'http://52.66.209.218:3000/getVersion';

    var response;
    response = await get(Uri.parse(uri));

    if (response.statusCode == 200) {
      var data = json.decode(response.body.toString());
      androidVersion = data['androidVersion'];
      iOSVersion = data['iosVersion'];
    }
    return;
  }
}
