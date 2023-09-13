import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/home_page/home_page.dart';
import 'features/my_bookings/my_bookings.dart';

class ticket extends StatefulWidget {
  final String spotNo;
  final String? location;
  final String? eventName;
  final String? sportName;
  final String? name;
  final String? category;
  final String date;
  const ticket({
    Key? key,
    required this.spotNo,
    required this.location,
    required this.eventName,
    required this.sportName,
    required this.name,
    required this.category,
    required this.date,
  }) : super(key: key);

  @override
  State<ticket> createState() => _ticketState();
}

class _ticketState extends State<ticket> {
  @override
  Widget build(BuildContext context) {
    Future<bool> ok;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        ok = true as Future<bool>;
        return ok;
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Homepage.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: BoxDecoration(
                    color: Color(0xFF121F2B),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFAB4D4F),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Center(
                          child: Text(
                            'Booking Successful!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.035),
                          ),
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          color: const Color(0xFF121F2B),
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${widget.eventName!.length > 20 ? widget.eventName!.substring(0, 20) + '...' : widget.eventName}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.02),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.03,
                        )
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          color: const Color(0xFF121F2B),
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              '${widget.location}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.017),
                              //textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.width * 0.03,
                        )
                      ]),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.0002,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.74,
                            color: const Color(0xFF121F2B),
                            child: Row(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width * 0.37,
                                  child: Center(
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Name:',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${widget.name}', //TODO ADD NAME
                                            overflow: TextOverflow.ellipsis,
                                            //textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width * 0.37,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Spot:',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.spotNo, //TODO ADD SPOT
                                            overflow: TextOverflow.ellipsis,
                                            //textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.03,
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.74,
                            color: const Color(0xFF121F2B),
                            child: Row(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width * 0.37,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Sport:',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${widget.sportName}', //TODO ADD SPORT
                                            overflow: TextOverflow.ellipsis,
                                            //textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width * 0.37,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Category:',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${widget.category}",
                                            overflow: TextOverflow.ellipsis,
                                            //textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.03,
                          )
                        ],
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.74,
                            color: const Color(0xFF121F2B),
                            child: Row(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width * 0.74,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Date:',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            widget.date,
                                            overflow: TextOverflow.ellipsis,
                                            //textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.03,
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        '#PlayBoldBeArdent',
                        style: GoogleFonts.hennyPenny(
                            color: const Color(0xFFE54545), fontSize: 22),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.04),
                    color: const Color(0xffD15858),
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.to(const MyBookings());
                    },
                    child: Center(
                      child: Text(
                        "Go to My Booking >",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
