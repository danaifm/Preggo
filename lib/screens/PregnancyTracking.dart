// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields, unnecessary_import, sized_box_for_whitespace, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PregnancyTracking extends StatefulWidget {
  const PregnancyTracking({super.key});

  @override
  _PregnancyTracking createState() => _PregnancyTracking();
}

class _PregnancyTracking extends State<PregnancyTracking> {
  String babyHeight = ' ';
  String babyWeight = ' ';
  String babyPicture = 'assets/images/w01-02.jpg';

  //_PregnancyTracking(); ??what is this

  List<dynamic> weeks = [];

  toJson() {
    return {'height': babyHeight, 'weight': babyWeight, 'image': babyPicture};
  }

  final firestore = FirebaseFirestore.instance.collection('pregnancytracking');

  @override
  void initState() {
    getWeek();
    super.initState();
  }

  getWeek() async {
    final QuerySnapshot snapshot = await firestore.get();

    firestore.doc((selected + 1).toString()).get().then((DocumentSnapshot doc) {
      setState(() {
        babyPicture = doc['image'].toString();
        babyHeight = doc['height'].toString();
        babyWeight = doc['weight'].toString();
      });
      print(doc['weight'].toString());
      print(doc['height'].toString());
      print(doc['image'].toString());

      setState(() {
        weeks = snapshot.docs;
      });
    });
  }

  double itemWidth = 60.0;
  int itemCount = 40;
  int selected = 0;
  FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 0);
  @override
  Widget build(BuildContext context) {
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
                },
                controller: _scrollController,
                itemExtent: itemWidth,
                children: List.generate(
                  itemCount,
                  (x) => RotatedBox(
                    quarterTurns: 1,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: x == selected ? 70 : 60,
                      height: x == selected ? 80 : 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: x == selected
                              ? const Color.fromRGBO(249, 220, 222, 1)
                              : Colors.transparent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        'week \n \n    ${x + 1}', // so it starts from week 1
                        style: const TextStyle(fontFamily: 'Urbanist'),
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
                    const Text(
                      'height',
                      style: TextStyle(fontFamily: 'Urbanist', fontSize: 12),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: 300,
            width: 330,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: const Color.fromRGBO(249, 220, 222, 1), width: 1.5),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                const BoxShadow(
                    blurRadius: 2, spreadRadius: 0.5, color: Colors.grey)
              ],
            ),
          )
        ],
      ),
    );
  }
}
