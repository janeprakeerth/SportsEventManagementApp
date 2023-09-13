import 'dart:convert';
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
import '../cricket_module/cricket_details_data_class.dart';
import '../cricket_module/cricket_details_item.dart';
import 'cricket_pool_details_model.dart';

class CricketPool extends StatefulWidget {
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

  const CricketPool({
    Key? key,
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
    required this.AllCategoryDetails,
  }) : super(key: key);
  @override
  State<CricketPool> createState() => _CricketPoolState();
}

class _CricketPoolState extends State<CricketPool> {
  PageController pageController = PageController(viewportFraction: 0.9);
  double _currPageValue = 0.0;
  List<String> PoolSizes = ['4', '8', '16', '32', '64'];
  List<String> TeamSizes = ['5', '6', '7', '8', '9', '10', '11', '12'];
  List<String> SubstitueSizes = ['2', '3', '4', '5'];
  List<String> BallType = ["Hard Tennis", "Soft Tennis", "Leather", "Other"];

  String? SelectedPoolSize;
  String? Points;

  List<String> PerMatchEstimatedTime = ['5', '10', '20', '30', '60'];
  String? SelectedPerMatchEstimatedTime;

  List<details>? poolDetails = [];
  List<CricketDetailsItem> pools = [];

  //make this false parth
  bool isPaymentDone = true;

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
      var poolData = CricketDetailsDataClass();
      pools.add(
        CricketDetailsItem(
          details: details,
          pooldata: poolData,
        ),
      );
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
        decoration: const BoxDecoration(
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
                        var data = pools.map((it) => it.pooldata).toList();

                        String poolsize_details = "";
                        String entryfee_details = "";
                        String BallType = "";
                        String Overs = "";
                        String Substitutes = "";
                        String TeamSize = "";
                        for (int i = 0; i < data.length; i++) {
                          poolsize_details += data[i].PoolSize;
                          entryfee_details += pools[i].pooldata.EntryFee;
                          BallType += pools[i].pooldata.BallType;
                          Overs += pools[i].pooldata.Overs;
                          Substitutes += pools[i].pooldata.Substitute;
                          TeamSize += pools[i].pooldata.TeamSize;
                        }
                        EasyLoading.show(
                          status: 'Loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var obtianedEmail = prefs.getString('email');
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
                        final ChallengeDetails = CreateChallengeDetails(
                            ORGANIZER_NAME: widget.EventManagerName,
                            ORGANIZER_ID: widget.EventManagerMobileNo,
                            USERID: obtianedEmail!.trim(),
                            TOURNAMENT_ID: "123456",
                            CATEGORY: Category,
                            NO_OF_KNOCKOUT_ROUNDS: poolsize_details,
                            ENTRY_FEE: entryfee_details,
                            GOLD: "0",
                            SILVER: "0",
                            BRONZE: "0",
                            OTHER: "0",
                            PRIZE_POOL: "0",
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
                            NO_OF_COURTS: "1",
                            BREAK_TIME: widget.BreakTime,
                            SPORT: widget.SportName,
                            TEAM_SIZE: TeamSize,
                            SUBSTITUTES: Substitutes,
                            BALL_TYPE: BallType,
                            OVERS: Overs);
                        final DetailMap = ChallengeDetails.toMap();
                        final json = jsonEncode(DetailMap);
                        // var url = "http://7e26-2401-4900-234a-2aa6-8597-daf-a06f-b504.ngrok.io/createMultipleTournament";

                        try {
                          var response = await post(createMultipleTournamentApi,
                              headers: {
                                "Accept": "application/json",
                                "Content-Type": "application/json"
                              },
                              body: json,
                              encoding: Encoding.getByName("utf-8"));
                          Map<String, dynamic> jsonData =
                              jsonDecode(response.body);
                          debugPrint('Response body:$json');
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
                          EasyLoading.showError(e.toString());
                          EasyLoading.dismiss();
                        }
                      },
                child: const Text("Create Tournament",
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
                child: const Text("Make Payment",
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
    servicewrapper wrapper = new servicewrapper();
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
