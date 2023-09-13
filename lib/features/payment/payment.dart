import 'dart:async';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import '../../Model/model_order_id.dart';
import 'package:ardent_sports/ticket.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../orderAPI/service_wrapper.dart';

class Payment extends StatefulWidget {
  final String? userId;
  final String tourneyId;
  final String? tourneyName;
  late String entryFee;
  final String? sportName;
  final String? location;
  final String date;
  final String spotNo;
  final String category;
  final Socket socket;

  Payment({
    Key? key,
    required this.userId,
    required this.tourneyId,
    required this.tourneyName,
    required this.entryFee,
    required this.sportName,
    required this.location,
    required this.date,
    required this.spotNo,
    required this.category,
    required this.socket,
  }) : super(key: key);
  @override
  State<Payment> createState() => _PaymentState();
}

class Tourney_Id {
  late String tourneyId;
  late String spotNo;
  String? userId;
  Tourney_Id(
      {required this.tourneyId, required this.spotNo, required this.userId});
  Map<String, dynamic> toMap() {
    return {
      "TOURNAMENT_ID": this.tourneyId,
      "btnId": this.spotNo,
      "USERID": this.userId
    };
  }
}

class _PaymentState extends State<Payment> {
  late Razorpay _razorpay;
  late double _progress;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    var amount = widget.entryFee;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SizedBox(
          height: h,
          child: Stack(
            children: [
              _header(w),
              _transparentImage(w),
              _paymentButton(w),
              Positioned(
                left: w * 0.4,
                top: w * 0.42,
                child: Text(
                  "PAYMENT",
                  style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.black),
                ),
              ),
              Positioned(
                left: w * 0.38,
                top: w * 0.48,
                child: Text(
                  '₹ $amount',
                  style: TextStyle(
                      fontSize: w * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Positioned(
                left: w * 0.18,
                top: w * 0.75,
                child: Text(
                  'PLAY BOLD BE ARDENT',
                  style: TextStyle(
                      fontSize: w * 0.06,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.black),
                ),
              ),
              Positioned(
                left: w * 0.252,
                top: w * 0.148,
                child: Text(
                  "Proceed To Pay",
                  style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Positioned(
                  left: w * 0.048,
                  top: w * 0.1,
                  child: TextButton(
                    child: Text(
                      "<",
                      style: TextStyle(
                          fontSize: w * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  _header(double w) {
    return SizedBox(
      height: w * 0.5,
      child: Stack(children: [
        _backgroundImage(w),
      ]),
    );
  }

  _backgroundImage(double w) {
    return Positioned(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(w * 0.08),
              bottomRight: Radius.circular(w * 0.08),
            ),
            image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/Rectangle 79.png"))),
      ),
    );
  }

  _transparentImage(double w) {
    return Positioned(
      top: w * 0.36,
      left: w * 0.01,
      child: Container(
        // margin: EdgeInsets.fromLTRB(75, 0, 0, 0),
        // padding: EdgeInsets.all(15.0),
        height: w * 0.56,
        width: MediaQuery.of(context).size.width - 10,

        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(w * 0.04)),
            image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/transparent.png"))),
      ),
    );
  }

  _paymentButton(double w) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.8,
      left: w * 0.2,
      child: Container(
        height: w * 0.1,
        width: w * 0.6,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(w * 0.03),
            ),
          ),
          onPressed: () async {
            _getorderId(widget.entryFee);
          },
          child: Text(
            "Pay Now",
            style: TextStyle(
              fontSize: w * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  _getorderId(String amount) async {
    _progress = 0;
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);

    print(" call start here");
    servicewrapper wrapper = servicewrapper();
    Map<String, dynamic> response = await wrapper.call_order_api(amount);
    final model = ModelOrderID.fromJson(response);
    print(" response here");
    if (model != null) {
      if (model.status == 1) {
        EasyLoading.dismiss(animation: true);

        print(" order id is  - " + model.orderID.toString());
        _startPayment(model.orderID.toString(), amount);
      } else {
        print(" status zero");
      }
    } else {
      print(" model null for category api");
    }
  }

  _startPayment(String orderID, String amount) {
    var options = {
      //rzp_live_4JAecB352A9wtt
      'key': 'rzp_live_4JAecB352A9wtt',
      'amount': amount,
      'order_id': orderID,
      'name': 'Ardent Sports',
      'description': 'Payment for Spot Booking',
      'prefill': {'contact': '', 'email': ''}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(" razorpay error " + e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds

    final tourneyId = Tourney_Id(
        tourneyId: widget.tourneyId,
        spotNo: widget.spotNo,
        userId: widget.userId);
    widget.socket.emit('confirm-booking', jsonEncode(tourneyId.toMap()));
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: ticket(
              eventName: widget.tourneyName,
              name: widget.userId,
              spotNo: widget.spotNo,
              date: widget.date,
              location: widget.location,
              sportName: widget.sportName,
              category: widget.category,
            )));
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
}
