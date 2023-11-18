// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields, unnecessary_import, sized_box_for_whitespace, library_private_types_in_public_api, avoid_print, prefer_interpolation_to_compose_strings, prefer_const_constructors, unnecessary_cast, prefer_typing_uninitialized_variables, unnecessary_new

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:preggo/colors.dart';

class weeklyModel {}

class PregnancyTracking extends StatefulWidget {
  const PregnancyTracking({super.key});

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
    getStrCurrentWeek();
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

  int currentWeekProgress = 0;
  String currentWeekPregnant = "";

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
        .where("ended", isEqualTo: 'false') //get current pregnancy
        .get();

    if (subCollectionRef.docs.isNotEmpty) {
      //SHE IS CURRENTLY PREGNANT
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
    } else {
      return -1;
    }
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
      for (var doc in querySnapshot.docs) {
        print('Doc => ${doc.data()}');
        List<String> eachWeek = [
          doc['height'],
          doc['weight'],
          doc['image'],
          doc['babychanges'],
          doc['motherchanges']
        ];
        // print(eachWeek);
        allWeeks[int.parse(doc.id) - 1] = (eachWeek);
      }
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

  var data;

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
              if (currentWeekProgress<=280 && snapshot.data != -1) {
                data = snapshot.data;
                // _scrollController.animateToItem(data - 1,
                //     duration: Duration(milliseconds: 500), curve: Curves.linear);

                // Extracting data from snapshot object

                // print("DATA is " + data.toString());
                // if (data == null) {
                //   _scrollController = FixedExtentScrollController(initialItem: 0);
                // } else {

                // }
                return Scaffold(
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 20, top: 45),
                                  child: Row(
                                    children: [
                                      RichText(
                                        text: const TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Urbanist',
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: 'Baby Tracker',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ]),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          Container(
                            height: 130,
                            //alignment: Alignment.topCenter,
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: ListWheelScrollView(
                                physics: BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        children: [
                                          Text(
                                            '\nweek\n \n    ${x + 1}',
                                            // so it starts from week 1
                                            style:
                                                TextStyle(fontFamily: 'Urbanist'),
                                          ),
                                          x + 1 == data
                                              ? Flexible(
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Icon(
                                                          Icons.expand_less)))
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(5),
                            width: 330,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromRGBO(249, 220, 222, 1),
                                width: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 2,
                                    spreadRadius: 0.5,
                                    color: Colors.grey)
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  //baby pic
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          AssetImage("assets/images/sperm.png"),
                                    ),
                                    borderRadius: BorderRadius.circular(500),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Slider(
                                        value: currentWeekProgress.toDouble(),
                                        min: 0,
                                        max: 280,
                                        //this was giving me error so i changed it but idk what it is
                                        onChanged: (double value) {},
                                        activeColor: pinkColor,
                                        inactiveColor: NavBraGrayColor,
                                      ),
                                      Text(
                                        "You’re currently pregnant in week $data",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  //baby pic
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage("assets/images/baby.png"),
                                    ),
                                    borderRadius: BorderRadius.circular(500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(5),
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
                            child: Column(
                              children: [
                                Text(
                                  'Highlights of The Week',
                                  style: TextStyle(
                                    color: pinkColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(motherChanges())
                              ],
                            ),
                          ),
                          Visibility(
                            visible: selected != 0 && selected != 1,
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(5),
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
                              child: Column(
                                children: [
                                  Text(
                                    'Baby Development ',
                                    style: TextStyle(
                                      color: pinkColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(babyChanges())
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 20, 50),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(55, 55),
                            shape: const CircleBorder(),
                          ),

                          child: Text("end"),
                          onPressed: () async  {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext contextx) {
                                return AlertDialog(
                                  // <-- SEE HERE
                                  content:
                                  const SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            'Are you sure you want to \nend your pregnancy?',
                                            textAlign:
                                            TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                              style: ElevatedButton
                                                  .styleFrom(
                                                backgroundColor:
                                                blackColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        40)),
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 30,
                                                    top: 15,
                                                    right: 30,
                                                    bottom: 15),
                                              ),
                                              child: const Text(
                                                "Cancel",
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                Navigator.pop(
                                                    context);
                                                await end();
                                              },
                                              style: ElevatedButton
                                                  .styleFrom(
                                                backgroundColor:
                                                Colors.red,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        40)),
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 30,
                                                    top: 15,
                                                    right: 30,
                                                    bottom: 15),
                                              ),
                                              child: const Text(
                                                "yes",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    )
                    ],
                  ),
                );
              }
              
              
              








              
              
               else {
                return Text('not pregnant');
              }













            }
          }

          return Scaffold(
            body: Center(
              child: Container(
                // height: 200,
                // width: 200,
                child: CircularProgressIndicator(
                  color: pinkColor,
                  strokeWidth: 5,
                ),
              ),
            ),
          );
        });
  }

  String babyChanges() {
    final baby = allWeeks[selected][3].toString().split('.');
    String changes = "";
    for (var element in baby) {
      changes += "$element\n";
    }
    return changes;
  }

  String motherChanges() {
    final mother = allWeeks[selected][4].toString().split('.');
    String changes = "";
    for (var element in mother) {
      changes += "$element\n";
    }
    return changes;
  }

  getStrCurrentWeek() async {
    Timestamp timestamp = Timestamp.now();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("pregnancyInfo")
        .get()
        .then((value) async{
      for (var element in value.docs) {
        if (element.data()["ended"] == "false") {
          timestamp = element.data()["DueDate"];
        }
      }
      var date = timestamp.toDate();
      currentWeekProgress = 280 - date.difference(DateTime.now()).inDays;
      DateTime today = DateTime.now();
      int weeksPregnant = 40 - (date.difference(today).inDays) ~/ 7;
      currentWeekPregnant = weeksPregnant.toString();
      if( currentWeekProgress>280)
        await end();
      setState(() {});
    });
  }

  Future end() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("pregnancyInfo")
        .get()
        .then((value) async {
      for (var element in value.docs) {
        if (element.data()["ended"] == "false") {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("pregnancyInfo")
              .doc(element.id)
              .update({"ended": "true"});
        }
      }
      setState(() {});
    });
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    CollectionReference subCollectionRefReminder =
        userDocRef.collection('reminders');
    QuerySnapshot subCollectionQueryReminder =
        await subCollectionRefReminder.get();
    for (QueryDocumentSnapshot doc in subCollectionQueryReminder.docs) {
      DocumentReference docRefReminder = subCollectionRefReminder.doc(doc.id);
      await docRefReminder.delete();
    }
    showDialog(
        barrierDismissible:
        false,
        context:
        context,
        builder:
            (
            context2) {
          return Center(
            child:
            SizedBox(
              height: MediaQuery
                  .sizeOf(
                  context)
                  .height *
                  0.40,
              width: MediaQuery
                  .sizeOf(
                  context)
                  .width *
                  0.85,
              child:
              Dialog(
                child:
                Container(
                  padding:
                  const EdgeInsets
                      .all(
                      10),
                  decoration:
                  const BoxDecoration(
                    color: Color
                        .fromRGBO(
                        255,
                        255,
                        255,
                        1),
                    borderRadius:
                    BorderRadius
                        .all(
                      Radius
                          .circular(
                          20),
                    ),
                  ),
                  child:
                  Center(
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly,
                      mainAxisSize: MainAxisSize
                          .min,
                      children: [
                        const SizedBox(
                            height: 20),
                        Container(
                          padding: const EdgeInsets
                              .all(
                              15),
                          decoration: const BoxDecoration(
                            shape: BoxShape
                                .circle,
                            color: green,
                            //color: pinkColor,
                            // border: Border.all(
                            //   width: 1.3,
                            //   color: Colors.black,
                            // ),
                          ),
                          child: const Icon(
                            Icons
                                .check,
                            color: Color
                                .fromRGBO(
                                255,
                                255,
                                255,
                                1),
                            size: 35,
                          ),
                        ),
                        const SizedBox(
                            height: 25),

                        // Done
                        const Text(
                          "your pregnancy is ended!",
                          textAlign: TextAlign
                              .center,
                          style: TextStyle(
                            color: Color
                                .fromARGB(
                                255,
                                0,
                                0,
                                0),
                            fontSize: 17,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight
                                .w700,
                            height: 1.30,
                            letterSpacing: -0.28,
                          ),
                        ),

                        const SizedBox(
                            height: 20),

                        /// OK Button
                        Container(
                          padding: const EdgeInsets
                              .symmetric(
                              horizontal: 10),
                          width: MediaQuery
                              .sizeOf(
                              context)
                              .width *
                              0.80,
                          height: 45.0,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (mounted) {
                                  // Navigator.pushAndRemoveUntil(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (_) =>
                                  //       const LoginScreen()),
                                  //       (route) => false,
                                  // );
                                }
                              },
                              style: ElevatedButton
                                  .styleFrom(
                                backgroundColor: blackColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius
                                        .circular(
                                        40)),
                                padding: const EdgeInsets
                                    .only(
                                    left: 70,
                                    top: 15,
                                    right: 70,
                                    bottom: 15),
                              ),
                              child: const Text(
                                "OK",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

