import 'package:ardent_sports/Model/category_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home_page/home_page.dart';
import '../hosted_challenges/hosted_challenges.dart';

class CreateChallengeTicket extends StatelessWidget {
  final List<String> Tournament_ID;
  final List<CategorieDetails> CategorieNames;
  const CreateChallengeTicket(
      {Key? key, required this.Tournament_ID, required this.CategorieNames})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Container> getAllTicketIds() {
      List<Container> AllIds = [];
      for (int i = 0; i < Tournament_ID.length; i++) {
        var container = Container(
          child: Row(
            children: [
              Text(
                  "     ${CategorieNames[i].CategoryName} ${CategorieNames[i].AgeCategory} :    "),
              Text(Tournament_ID[i]),
            ],
          ),
        );
        AllIds.add(container);
      }
      return AllIds;
    }

    Future<bool> ok;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        ok = true as Future<bool>;
        return ok;
      },
      child: SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.red,
          body: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFE2434B),
                  Color(0xFF992D6C),
                ],
              )),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "SUCCESS !",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                      ),
                    ),
                  ),
                  //LEFT TO PUT PADDING
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      //color: Colors.white.withOpacity(0.2),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0))),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.022,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Your Challenge has been",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                      ),
                                    ),
                                    Text(
                                      "Successfully Published",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                      ),
                                    ),
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Kindly note the",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                      ),
                                    ),
                                    Text(
                                      "Scorer ID : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                      ),
                                    ),
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Card(
                                  color: Colors.black.withOpacity(0.2),
                                  child: ExpansionTile(
                                    title: Row(
                                      children: const [
                                        Text("Category Name :   "),
                                        Text("Tournament ID")
                                      ],
                                    ),
                                    children: getAllTicketIds(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  Get.to(HostedChallenges());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "View Your challenge   >",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
