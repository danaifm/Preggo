// ignore_for_file: use_key_in_widget_constructors, camel_case_types, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/pregnancyInfo.dart';
import 'package:preggo/main.dart';

class startJourney extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _startJourney();
  }
}

class _startJourney extends State<startJourney>{
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: backGroundPink,

      body: Column(
        children: [
          SizedBox(height: 100,), //120 is exactly like pregnancyInfo page 

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 0.0,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(80.0),
                  ),
              ),

              child: Column(
                children: [
                  Center(
                  child: Padding(
                  padding: EdgeInsets.only(top: 90),
                  child: Image.asset('assets/images/calendar.png', height: 280, width: 280,
                  
                  ),
                ),
              ),             
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 25),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Start New Journey",
                style: TextStyle(
                  color:darkBlackColor,
                  fontSize: 34,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  height: 1.30,
                  letterSpacing: -0.28,
                  
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 25),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Add new pregnancy details",
                style: TextStyle(
                  color: pinkColor,
                  fontSize: 20,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  height: 1.30,
                  letterSpacing: -0.28,
                  
                ),
              ),
            ),
          ),

          Row(
            children: [
              /*Padding(
                padding: EdgeInsets.fromLTRB(40, 80, 0, 0),
                child: Text(
                  'skip',
                  style: TextStyle(
                    color: grayColor,
                    fontSize: 20,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w200,
                    height: 1.30,
                    letterSpacing: -0.28,
                  ),
                ),
              ), */ //uncomment when admin page gets added 
              Padding(
                padding: EdgeInsets.fromLTRB(240, 60, 0, 0),
                child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => pregnancyInfo()));
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(55, 55),
                  shape: const CircleBorder(),
                  backgroundColor: darkBlackColor,
                ),
                child: const Text(
                  '+',
                  style: TextStyle(fontSize: 38),
                ),
              ),
              ),
            ],
          ),

              ],
            )  
              
            ),
          ),

        ],
      ),

    );
  }

}

