// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields, unnecessary_import, sized_box_for_whitespace, library_private_types_in_public_api, avoid_print, prefer_interpolation_to_compose_strings, prefer_const_constructors, unnecessary_cast, prefer_typing_uninitialized_variables, unnecessary_new

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:preggo/colors.dart';

class weeklyModel {}

class PregnancyTracking extends StatefulWidget {
  PregnancyTracking({super.key});
  //late final String userId;

  @override
  State<StatefulWidget> createState() {
    return _PregnancyTracking();
  }
}

class _PregnancyTracking extends State<PregnancyTracking> {
  @override
  void initState() {
    getAllWeeks();
    super.initState();
    // getWeek();
  }

  String babyHeight = ' ';
  String babyWeight = ' ';
  String babyPicture = 'assets/images/w01-02.jpg';
  int weekNo = 0;
  var duedate;

  // _PregnancyTracking({
  //   required this.weekNo,
  //   required this.babyHeight,
  //   required this.babyWeight,
  //   required this.babyPicture,
  // });

  toJson(DocumentSnapshot doc) {
    return {
      "weekNo": doc.id,
      "babyHeight": doc['height'],
      "babyWeight": doc['weight'],
      "babyPicture": doc['image']
    };
  }

  int currentWeek = 1;

  var firestore = FirebaseFirestore.instance.collection('pregnancytracking');
  late final Future myFuture = getDueDate();
  FixedExtentScrollController _scrollController = FixedExtentScrollController();

  Future<int> getDueDate() async {
    await getAllWeeks();
    //var today = DateTime.now();
    var subCollectionRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('pregnancyInfo')
        .where("DueDate", isGreaterThanOrEqualTo: Timestamp.now())
        .get();
    var data = subCollectionRef.docs.first.data() as Map;
    duedate = data['DueDate'];
    var cWeek = getCurrentWeek(duedate.toDate());
    // print("due date is ${duedate.toDate()}");

    // if (mounted) {
    // setState(() {
    print("scrolling to " + (cWeek - 1).toString());
    // _scrollController.animateToItem(cWeek - 1,
    //     duration: Duration(milliseconds: 500), curve: Curves.linear);
    //selected = cWeek - 1;
    //   });
    // }
    return cWeek;
  }

  int getCurrentWeek(var duedate) {
    var today = DateTime.now();
    final difference = duedate.difference(today).inDays / 7;
    //print("current week is " + difference.round()).toString();
    // if (mounted) {
    //   setState(() {

    // if (true) {
    //   _scrollController.animateToItem(myCurrWeek - 1,
    //       duration: Duration(milliseconds: 500), curve: Curves.linear);
    //   print("scrolling to " + (myCurrWeek - 1).toString());
    // }
    //   });
    // }
    int ans = 40 - (difference.round() as int);
    return ans;
  }

  int row = 40;
  int col = 4;
  // List<List<String>> allWeeks = <List<String>>[];
  var allWeeks = List<List>.generate(
      40, (i) => List<dynamic>.generate(4, (index) => null, growable: false),
      growable: false);
  late int selected = 0;

  getAllWeeks() async {
    var weeks = await firestore.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        List<String> eachWeek = [doc['height'], doc['weight'], doc['image']];
        // print(eachWeek);
        allWeeks[int.parse(doc.id) - 1] = (eachWeek);
      });
    });
    // print(allWeeks);
    // print(allWeeks.length);
  }

  // getWeek() async {
  //   //final QuerySnapshot snapshot = await firestore.get();

  //   firestore.doc((selected + 1).toString()).get().then((DocumentSnapshot doc) {
  //     setState(() {
  //       babyPicture = doc['image'].toString();
  //       babyHeight = doc['height'].toString();
  //       babyWeight = doc['weight'].toString();
  //     });
  //     print(doc['weight'].toString());
  //     print(doc['height'].toString());
  //     print(doc['image'].toString());

  //     // setState(() {
  //     // weeks = snapshot.docs;
  //     //});
  //   });
  // }

  // jumptoIndex(int cWeek) {
  //   _scrollController.jumpToItem(cWeek - 1);
  // }
  handleScroll(int x) {
    setState(() {
      selected = x;
    });
  }

  bool first = true;
  double itemWidth = 60.0;
  int itemCount = 40;
  @override
  Widget build(BuildContext context) {
    // getAllWeeks();
    //getDueDate();
    // getCurrentWeek();
    return FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // print("snapshot is null");
              return Container();
            } //end if
            else if (snapshot.hasData) {
              final data = snapshot.data;
              // _scrollController.animateToItem(data - 1,
              //     duration: Duration(milliseconds: 500), curve: Curves.linear);

              // Extracting data from snapshot object

              // print("DATA is " + data.toString());
              // if (data == null) {
              //   _scrollController = FixedExtentScrollController(initialItem: 0);
              // } else {

              // }
              return Scaffold(
                body: Column(
                  children: [
                    Container(
                      height: 180,
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: ListWheelScrollView(
                          // useMagnifier: true,
                          // magnification: 1.15,
                          onSelectedItemChanged: (x) {
                            setState(() {
                              selected = x;
                            });
                            // print("WEEK" + (selected + 1).toString());
                            //getWeek();
                            // getDueDate();
                          },
                          controller: _scrollController,
                          itemExtent: itemWidth,
                          children: List.generate(
                            itemCount,
                            (x) => RotatedBox(
                              quarterTurns: 1,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                width: x == selected ? 70 : 60,
                                height: x == selected ? 80 : 70,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: x == selected
                                        ? Color.fromRGBO(249, 220, 222, 1)
                                        : Colors.transparent,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  'week \n \n    ${x + 1}', // so it starts from week 1
                                  style: TextStyle(fontFamily: 'Urbanist'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        //weight icon
                        Container(
                          width: 90,
                          height: 70,
                          child: Column(
                            children: [
                              Icon(
                                Icons.monitor_weight_outlined,
                                color: Color.fromARGB(255, 163, 39, 39),
                              ),
                              Text(
                                allWeeks[selected][1],
                                style: TextStyle(
                                    fontFamily: 'Urbanist', fontSize: 15),
                              ),
                              Text(
                                'Weight',
                                style: TextStyle(
                                    fontFamily: 'Urbanist', fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        Container(
                          //baby pic
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(allWeeks[selected][2]),
                            ),
                            borderRadius: BorderRadius.circular(500),
                          ),
                        ),

                        Container(
                          //length icon
                          width: 90,
                          height: 70,
                          child: Column(
                            children: [
                              Icon(
                                Icons.straighten,
                                color: Colors.teal[800],
                              ),
                              Text(
                                allWeeks[selected][0],
                                style: TextStyle(
                                    fontFamily: 'Urbanist', fontSize: 15),
                              ),
                              Text(
                                'height',
                                style: TextStyle(
                                    fontFamily: 'Urbanist', fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 300,
                      width: 330,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Color.fromRGBO(249, 220, 222, 1),
                            width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 0.5,
                              color: Colors.grey)
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          }

          return Scaffold(
            body: Center(
              child: Container(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(
                  color: pinkColor,
                  strokeWidth: 5,
                ),
              ),
            ),
          );
        });
  }
}
