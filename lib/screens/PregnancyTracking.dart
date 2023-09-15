// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields, unnecessary_import, sized_box_for_whitespace, library_private_types_in_public_api, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PregnancyTracking extends StatefulWidget {
  PregnancyTracking({super.key});
  //late final String userId;

  @override
  State<StatefulWidget> createState() {
    return _PregnancyTracking();
  }
}

class _PregnancyTracking extends State<PregnancyTracking> {
  String babyHeight = ' ';
  String babyWeight = ' ';
  String babyPicture = 'assets/images/w01-02.jpg';
  var duedate;

  int currentWeek = 1;

  var firestore = FirebaseFirestore.instance.collection('pregnancytracking');

  @override
  void initState() {
    getWeek();
    super.initState();
  }

  getDueDate() async {
    //var today = DateTime.now();
    var subCollectionRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('pregnancyInfo')
        .where("DueDate", isGreaterThanOrEqualTo: Timestamp.now())
        .get();

    var data = subCollectionRef.docs.first.data() as Map;
    duedate = data['DueDate'];
    //var today = DateTime.now();
    //print("today is " + today.toString());
    print("due date is ${duedate.toDate()}");
    return getCurrentWeek(duedate.toDate());

    /*var query = subCollectionRef
        .where('DueDate', isGreaterThanOrEqualTo: today)
        .get() as Map<String, dynamic>;
    print(query.toString());*/
  }

  getCurrentWeek(var duedate) {
    var today = DateTime.now();
    final difference = duedate.difference(today).inDays / 7;
    //print("current week is " + difference.round()).toString();
    if (mounted) {
      setState(() {
        myCurrWeek = difference.round();
      });
    }
    return difference.round();
  }

  int myCurrWeek = 0;

  getWeek() async {
    //final QuerySnapshot snapshot = await firestore.get();

    firestore.doc((selected + 1).toString()).get().then((DocumentSnapshot doc) {
      setState(() {
        babyPicture = doc['image'].toString();
        babyHeight = doc['height'].toString();
        babyWeight = doc['weight'].toString();
      });
      print(doc['weight'].toString());
      print(doc['height'].toString());
      print(doc['image'].toString());

      // setState(() {
      // weeks = snapshot.docs;
      //});
    });
  }

  double itemWidth = 60.0;
  int itemCount = 40;
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    var week = getDueDate();
    // getCurrentWeek();
    FixedExtentScrollController _scrollController =
        FixedExtentScrollController(initialItem: 0); //exception hereeeeee
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 180,
            child: RotatedBox(
              quarterTurns: -1,
              child: ListWheelScrollView(
                magnification: 2.0,
                onSelectedItemChanged: (x) {
                  setState(() {
                    selected = x;
                  });
                  print("WEEK" + (selected + 1).toString());
                  getWeek();
                  getDueDate();
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
                      babyWeight,
                      style: TextStyle(fontFamily: 'Urbanist', fontSize: 15),
                    ),
                    Text(
                      'Weight',
                      style: TextStyle(fontFamily: 'Urbanist', fontSize: 12),
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
                    image: AssetImage(babyPicture),
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
                      babyHeight,
                      style: TextStyle(fontFamily: 'Urbanist', fontSize: 15),
                    ),
                    Text(
                      'height',
                      style: TextStyle(fontFamily: 'Urbanist', fontSize: 12),
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
                  color: Color.fromRGBO(249, 220, 222, 1), width: 1.5),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(blurRadius: 2, spreadRadius: 0.5, color: Colors.grey)
              ],
            ),
          )
        ],
      ),
    );
  }
}
