// ignore_for_file: use_key_in_widget_constructors, camel_case_types, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/main.dart';

class postReply extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _postReply();
  }
}

class _postReply extends State<postReply>{
  String getTimestamp(){
    DateTime stamp = DateTime.now();
    String formattedStamp = DateFormat('yyyy/MM/dd hh:mm a').format(stamp);
    return formattedStamp;

  }
  
  String postTitle = "What stroller should I buy?";
  String postBody = "I'm trying to buy a new stroller for my newborn but I'm not sure which one to get. Can I get any newborn safe recommendations?"; 
  String username = "Rana"; 


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      

      body: Stack(
        children: [
          
          Center(
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10,),
              height:110,
              width: 350,
              decoration: BoxDecoration(
                color: backGroundPink.withOpacity(0.3),
                border: Border.all(color: backGroundPink, width: 2),
                borderRadius: BorderRadius.circular(13),
              ),
              child: 
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Icon(
                      Icons.account_circle_outlined,
                      color: Colors.black,
                      size: 38,
                    ),
                    Text(
                    "$username ",
                    style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                  
                    ],
                  ),
                  SizedBox(width: 30,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                        postTitle,
                        style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w800,
                        height: 1.30,
                        letterSpacing: -0.28,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Expanded(
                        child: Text(
                          postBody,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: true,
                          style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w600,
                          height: 1.30,
                          letterSpacing: -0.28,
                          ),
                        ),
                      ),
                      SizedBox(height: 4,),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          getTimestamp(),
                          style: TextStyle(
                          color: Color.fromARGB(200, 121, 113, 113),
                          fontSize: 9,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w700,
                          height: 1.30,
                          letterSpacing: -0.28,
                          ),
                        ),
                      ),
                          
                      ],
                      ),
                  ),
                ],
              ),
                    
            ),
          ),

          
          
        ],
      ),

    );
  }

}

