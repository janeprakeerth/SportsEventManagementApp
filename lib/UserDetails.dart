class UserDetails {
  late String USERID;
  late String PHONE;
  late String NAME;
  late String EMAIL;
  late String PWD;
  late String GENDER;
  late String DOB;
  late String CITY;
  late String STATE;
  late String SPORTS_ACADEMY;
  late String PROFILE_ID;
  late String INTERESTED_SPORTS;
  List FRIENDS_LIST = [];
  UserDetails(
      {required this.USERID,
      required this.PHONE,
      required this.NAME,
      required this.EMAIL,
      required this.PWD,
      required this.GENDER,
      required this.DOB,
      required this.CITY,
      required this.STATE,
      required this.SPORTS_ACADEMY,
      required this.PROFILE_ID,
      required this.INTERESTED_SPORTS});
  Map<String, dynamic> toMap() {
    return {
      "USERID": USERID,
      "PHONE": PHONE,
      "NAME": NAME,
      "EMAIL": EMAIL,
      "PWD": PWD,
      "GENDER": GENDER,
      "DOB": DOB,
      "CITY": CITY,
      "STATE": STATE,
      "SPORTS_ACADEMY": SPORTS_ACADEMY,
      "PROFILE_ID": PROFILE_ID,
      "INTERESTED_SPORTS": INTERESTED_SPORTS,
      "FRIENDS_LIST": FRIENDS_LIST,
    };
  }
}

class LoginDetails {
  late String EmailId;
  late String Password;
  LoginDetails({required this.EmailId, required this.Password});
  Map<String, dynamic> toMap() {
    return {
      "loginid": EmailId,
      "pwd": Password,
    };
  }
}
