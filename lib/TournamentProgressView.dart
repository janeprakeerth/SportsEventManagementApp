import 'dart:math';
import 'package:flutter/material.dart';

class TournamentProgressView extends StatefulWidget {
  const TournamentProgressView({Key? key}) : super(key: key);

  @override
  State<TournamentProgressView> createState() => _TournamentProgressViewState();
}

class _TournamentProgressViewState extends State<TournamentProgressView> {
  List<Container> builRows(int start, int end) {
    List<Container> totalRows = [];
    int x = 1;
    int dist_between_spots = 30;
    double top_push = 0;
    for (int i = start; i <= end; i++) {
      var newContainer = Container(
        margin: const EdgeInsets.only(left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getTotalSpots(1, (pow(2, end - 1) / x).toInt(),
              i.toDouble(), dist_between_spots.toDouble(), top_push),
        ),
      );
      totalRows.add(newContainer);
      x *= 2;
      top_push += dist_between_spots / 2 + 10;
      dist_between_spots = (dist_between_spots * 2) + 25;
    }
    return totalRows;
  }

  List<Container> getTotalSpots(int start, int end, double level,
      double dist_between_spots, double top_push) {
    List<Container> totalspots = [];

    for (int i = start; i <= end; i++) {
      if (i == 1) {
        var newContainer = Container(
          margin: EdgeInsets.only(top: top_push),
          width: 70,
          height: 25,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6EBC55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: const Text(
              "",
              style: TextStyle(fontSize: 10),
            ),
          ),
        );
        totalspots.add(newContainer);
      } else {
        var newContainer = Container(
          margin: EdgeInsets.only(top: dist_between_spots),
          width: 70,
          height: 25,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6EBC55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: const Text(
              "",
              style: TextStyle(fontSize: 10),
            ),
          ),
        );
        totalspots.add(newContainer);
      }
    }
    return totalspots;
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  child: buildAvailableSpotsCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAvailableSpotsCard() => Card(
        elevation: 10,
        color: Colors.white.withOpacity(0.1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: builRows(1, 4),
        ),
      );
}
