// ignore_for_file: prefer_const_constructors, non_constant_identifier_names
import 'dart:convert';
import 'package:ardent_sports/features/poll_details/pool_details_data_class.dart';
import 'package:ardent_sports/features/poll_details/pool_details_item.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/category_details_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:get/get.dart';
import '../../Helper/apis.dart';
import '../../Helper/constant.dart';
import '../../Model/model_order_id.dart';
import '../../orderAPI/service_wrapper.dart';
import '../cricket_module/create_challenge_ticket.dart';

class PoolDetails extends StatefulWidget {
  final String? SportName;
  final String EventManagerName;
  final String EventManagerMobileNo;
  final String? EventType;
  final String EventName;
  final String StartDate;
  final String EndDate;
  final String StartTime;
  final String EndTime;
  final String City;
  final String Address;
  final String? Category;
  final String? AgeCategory;
  final String RegistrationCloses;
  final String NoofCourts;
  final String BreakTime;
  final List<CategorieDetails> AllCategoryDetails;

  const PoolDetails(
      {Key? key,
      required this.SportName,
      required this.EventManagerName,
      required this.EventManagerMobileNo,
      required this.EventType,
      required this.EventName,
      required this.StartDate,
      required this.EndDate,
      required this.StartTime,
      required this.EndTime,
      required this.City,
      required this.Address,
      required this.Category,
      required this.AgeCategory,
      required this.RegistrationCloses,
      required this.NoofCourts,
      required this.BreakTime,
      required this.AllCategoryDetails})
      : super(key: key);
  @override
  State<PoolDetails> createState() => _PoolDetailsState();
}

class CreateChallengeDetails {
  late String ORGANIZER_NAME;
  late String ORGANIZER_ID;
  late String USERID;
  late String TOURNAMENT_ID;
  late String? CATEGORY;
  late String NO_OF_KNOCKOUT_ROUNDS;
  late String ENTRY_FEE;
  late String? GOLD;
  late String? SILVER;
  late String? BRONZE;
  late String? OTHER;
  late String? PRIZE_POOL;
  late String TOURNAMENT_NAME;
  late String CITY;
  late String? TYPE;
  late String LOCATION;
  late String START_DATE;
  late String END_DATE;
  late String START_TIME;
  late String END_TIME;
  late int REGISTRATION_CLOSES_BEFORE;
  late String AGE_CATEGORY;
  late String NO_OF_COURTS;
  late String BREAK_TIME;
  late String? SPORT;

  CreateChallengeDetails(
      {required this.ORGANIZER_NAME,
      required this.ORGANIZER_ID,
      required this.USERID,
      required this.TOURNAMENT_ID,
      required this.CATEGORY,
      required this.NO_OF_KNOCKOUT_ROUNDS,
      required this.ENTRY_FEE,
      required this.GOLD,
      required this.SILVER,
      required this.BRONZE,
      required this.OTHER,
      required this.PRIZE_POOL,
      required this.TOURNAMENT_NAME,
      required this.CITY,
      required this.TYPE,
      required this.LOCATION,
      required this.START_DATE,
      required this.END_DATE,
      required this.START_TIME,
      required this.END_TIME,
      required this.REGISTRATION_CLOSES_BEFORE,
      required this.AGE_CATEGORY,
      required this.NO_OF_COURTS,
      required this.BREAK_TIME,
      required this.SPORT});
  Map<String, dynamic> toMap() {
    return {
      "ORGANIZER_NAME": ORGANIZER_NAME,
      "ORGANIZER_ID": ORGANIZER_ID,
      "USERID": USERID,
      "TOURNAMENT_ID": TOURNAMENT_ID,
      "CATEGORY": CATEGORY,
      "NO_OF_KNOCKOUT_ROUNDS": NO_OF_KNOCKOUT_ROUNDS,
      "ENTRY_FEE": ENTRY_FEE,
      "GOLD": GOLD,
      "SILVER": SILVER,
      "BRONZE": BRONZE,
      "OTHER": OTHER,
      "PRIZE_POOL": PRIZE_POOL,
      "TOURNAMENT_NAME": TOURNAMENT_NAME,
      "CITY": CITY,
      "TYPE": TYPE,
      "LOCATION": LOCATION,
      "START_DATE": START_DATE,
      "END_DATE": END_DATE,
      "START_TIME": START_TIME,
      "END_TIME": END_TIME,
      "REGISTRATION_CLOSES_BEFORE": REGISTRATION_CLOSES_BEFORE,
      "AGE_CATEGORY": AGE_CATEGORY,
      "NO_OF_COURTS": NO_OF_COURTS,
      "BREAK_TIME": BREAK_TIME,
      "SPORT": SPORT
    };
  }
}

class details {
  late String PoolSize;
  late String gold;
  late String silver;
  late String bronze;
  late String others;
  late String entryfee;
  late String pointsystem;

  details({
    required this.PoolSize,
    required this.gold,
    required this.silver,
    required this.bronze,
    required this.others,
    required this.entryfee,
    required this.pointsystem,
  });
}

class _PoolDetailsState extends State<PoolDetails> {
  PageController pageController = PageController(viewportFraction: 0.9);
  double _currPageValue = 0.0;
  List<String> PoolSizes = ['8', '16', '32', '64'];
  String? SelectedPoolSize;
  List<String> PointSystems = ["21 best of 3", "15 best of 3", "11 best of 3"];
  String? SelectedPointSystem;
  String? Points;

  List<String> PerMatchEstimatedTime = ['5', '10', '20', '30', '60'];
  String? SelectedPerMatchEstimatedTime;

  List<details>? poolDetails = [];
  List<PoolDetailsItem> pools = [];

  bool isPaymentDone = false;

  final EntryFeeController = TextEditingController();
  // final PrizePoolController = TextEditingController();

  final gold = TextEditingController();
  final silver = TextEditingController();
  final bronze = TextEditingController();
  final others = TextEditingController();

  late Razorpay _razorpay;
  var tournament_id_arr;

  @override
  _saveBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('paymentDone', true);
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });

    for (CategorieDetails details in widget.AllCategoryDetails) {
      var poolData = PoolDetailsDataClass();
      pools.add(PoolDetailsItem(
        details: details,
        pooldata: poolData,
      ));

      print("details : ${details.AgeCategory}");
      print("details : ${details.CategoryName}");
      print(pools);

      print('widget.AllCategoryDetails :  ${widget.AllCategoryDetails}');

      print('pool Data : $pools');
    }
  }

  @override
  void dispose() {
    pageController.dispose();
  }

  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Homepage.png"), fit: BoxFit.cover)),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                addAutomaticKeepAlives: true,
                itemCount: pools.length,
                itemBuilder: (_, i) => pools[i],
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(
                      deviceWidth * 0.04,
                      deviceWidth * 0.02,
                      deviceWidth * 0.04,
                      deviceWidth * 0.02),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: isPaymentDone == false
                    ? null
                    : () async {
                        print('we are here ');
                        var data = pools.map((it) => it.pooldata).toList();

                        String poolsize_details = "";
                        String gold_details = "";
                        String silver_details = "";
                        String bronze_details = "";
                        String other_details = "";
                        String entryfee_details = "";
                        String selected_point_system_details = "";
                        String per_match_estimated_time = "";
                        for (int i = 0; i < data.length; i++) {
                          poolsize_details += data[i].PoolSize;
                          gold_details += data[i].Gold;
                          silver_details += pools[i].pooldata.Silver;
                          bronze_details += pools[i].pooldata.Bronze;
                          other_details += "0";
                          entryfee_details += pools[i].pooldata.EntryFee;
                          selected_point_system_details +=
                              pools[i].pooldata.PointSystem;
                          if (i != pools.length - 1) {
                            poolsize_details += "-";
                            gold_details += "-";
                            silver_details += "-";
                            bronze_details += "-";
                            other_details += "-";
                            entryfee_details += "-";
                            selected_point_system_details += "-";
                            per_match_estimated_time += "-";
                          }
                        }
                        EasyLoading.show(
                          status: 'Loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var obtianedEmail = prefs.getString('email');
                        print(obtianedEmail);
                        String Category = "";
                        String AgeCategory = "";
                        for (int i = 0;
                            i < widget.AllCategoryDetails.length;
                            i++) {
                          Category += widget.AllCategoryDetails[i].CategoryName;
                          AgeCategory +=
                              widget.AllCategoryDetails[i].AgeCategory;
                          if (i != widget.AllCategoryDetails.length - 1) {
                            Category += "-";
                            AgeCategory += "-";
                          }
                        }
                        print(Category);
                        print(gold_details);
                        print(silver_details);
                        print(bronze_details);
                        print(other_details);
                        print(entryfee_details);
                        print(widget.EventName);
                        print(widget.City);

                        var prizePool = gold_details +
                            "-" +
                            silver_details +
                            "-" +
                            bronze_details +
                            "-" +
                            other_details;

                        final ChallengeDetails = CreateChallengeDetails(
                            ORGANIZER_NAME: widget.EventManagerName,
                            ORGANIZER_ID: widget.EventManagerMobileNo,
                            USERID: obtianedEmail!.trim(),
                            TOURNAMENT_ID: "123456",
                            CATEGORY: Category,
                            NO_OF_KNOCKOUT_ROUNDS: poolsize_details,
                            ENTRY_FEE: entryfee_details,
                            GOLD: gold_details,
                            SILVER: silver_details,
                            BRONZE: bronze_details,
                            OTHER: other_details,
                            PRIZE_POOL: prizePool,
                            TOURNAMENT_NAME: widget.EventName,
                            CITY: widget.City,
                            TYPE: widget.EventType,
                            LOCATION: widget.Address,
                            START_DATE: widget.StartDate,
                            END_DATE: widget.EndDate,
                            START_TIME: widget.StartTime,
                            END_TIME: widget.EndTime,
                            REGISTRATION_CLOSES_BEFORE: 6,
                            AGE_CATEGORY: AgeCategory,
                            NO_OF_COURTS: widget.NoofCourts,
                            BREAK_TIME: widget.BreakTime,
                            SPORT: widget.SportName);
                        final DetailMap = ChallengeDetails.toMap();
                        final json = jsonEncode(DetailMap);
                        print(json);
                        print('Detail : ${ChallengeDetails.toMap()} ');
                        print('parameter : $json');
                        try {
                          var response = await post(createMultipleTournamentApi,
                              headers: {
                                "Accept": "application/json",
                                "Content-Type": "application/json"
                              },
                              body: json,
                              encoding: Encoding.getByName("utf-8"));

                          print('response : ${response.body.toString()}');
                          Map<String, dynamic> jsonData =
                              jsonDecode(response.body);
                          debugPrint('Response body:$json');
                          print(jsonData["TOURNAMENT_ID"]);
                          tournament_id_arr =
                              jsonData["TOURNAMENT_ID"].toString().split(',');
                          if (response.statusCode == 200) {
                            EasyLoading.dismiss();
                            Get.to(CreateChallengeTicket(
                              Tournament_ID: tournament_id_arr,
                              CategorieNames: widget.AllCategoryDetails,
                            ));
                            EasyLoading.dismiss();
                          } else {
                            EasyLoading.dismiss();
                            EasyLoading.showError(
                                "Error in Tournament Creation");
                          }
                        } catch (e) {
                          print("exception :  $e");
                          EasyLoading.showError(e.toString());
                          EasyLoading.dismiss();
                        }
                      },
                child: Text("Create Tournament",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.fromLTRB(
                      deviceWidth * 0.04,
                      deviceWidth * 0.02,
                      deviceWidth * 0.04,
                      deviceWidth * 0.02),
                ),
                child: Text("Make Payment",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                onPressed: isPaymentDone == true
                    ? null
                    : () {
                        _getorderId('2');
                      }),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  _getorderId(String amount) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black, status: 'Loading...');
    print(" call start here");
    servicewrapper wrapper = servicewrapper();
    Map<String, dynamic> response = await wrapper.call_order_api(amount);
    final model = ModelOrderID.fromJson(response);
    print(" response here");
    if (model != null) {
      if (model.status == 1) {
        EasyLoading.dismiss();
        print(" order id is  - " + model.orderID.toString());
        _startPayment(model.orderID.toString(), amount);
      } else {
        print(" status zero");
      }
    } else {
      print(" model null for category api");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds

    setState(() {
      isPaymentDone = true;
    });
    print(
        " RazorSuccess : " + response.paymentId! + " -- " + response.orderId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print(" RazorpayError : " +
        response.code.toString() +
        " -- " +
        response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print(" RazorWallet : " + response.walletName!);
  }

  _startPayment(String orderID, String amount) {
    var options = {
      //rzp_live_4JAecB352A9wtt
      'key': 'rzp_live_4JAecB352A9wtt',
      'amount': '2',
      'order_id': orderID,
      'name': 'Ardent Sports',
      'description': 'Payment for Spot Booking',
      'prefill': {'contact': '9999999999', 'email': 'ardentsports1@gmail.com'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(" razorpay error " + e.toString());
    }
  }
}
