// ignore_for_file: use_key_in_widget_constructors, camel_case_types, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:preggo/view_reminders.dart';


class reminderDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
   
    return _reminderDetails();
  }
}

class _reminderDetails extends State<reminderDetails>{
  

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  Widget getDayWidget(String id, String short) {

  return Container(

    width: 100,

    height: 50,

    decoration: BoxDecoration(

      color: backGroundPink,

      shape: BoxShape.rectangle,

    ),

    child: Center(

      child: Text(

        "Every $short",

        style: TextStyle(

          color: Colors.white,

          fontWeight: FontWeight.bold,

        ),

      ),

    ),

  );

}



Widget buildRepeatWidget(List<dynamic> repeat) {

  if (repeat.isEmpty) {

    return Text("none");

  } else {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.center,

      children: [

        for (var item in repeat)

          if (item is Map<String, dynamic>)

            getDayWidget(item["id"], item["short"]),

      ],

    );

  }

}

  Future<Container> reminderInfo(String reminderId) async {

    String userUid = getUserId();
    
    DocumentSnapshot reminder = await FirebaseFirestore.instance
    .collection('users').doc(userUid)
    .collection('reminders')
    .doc(reminderId)
    .get();

      if(reminder.exists){
        Map<String,dynamic> data =reminder.data() as Map<String,dynamic>;
        var title = data['title'];
        var time = data['time'];
        var date = data['date'];
        var repeat= data['repeat'];
        var desc= data['description'];

        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
          child: Column(
            children: [
              Row(
                children: [
                  
                  Text(
                    "Title: ",
                    style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                  Text(
                    "$title",
                    style: TextStyle(
                    color: pinkColor,
                    fontSize: 22,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                ],

              ),
              SizedBox(height: 15,),
              Column(
                children: [
                  
                  Row(
                    children: [
                      Text(
                        "Description: ",
                        style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w700,
                        height: 1.30,
                        letterSpacing: -0.28,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        " $desc",
                        style: TextStyle(
                        color: pinkColor,
                        fontSize: 22,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                        height: 1.30,
                        letterSpacing: -0.28,
                        ),
                      ),
                    ],
                  ),
                ],

              ),
              SizedBox(height: 15,),
              Row(
                
                children: [
                  Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                      size: 23,
                    ),
                    SizedBox(width: 10,),
                  
                  Text(
                    "Date: ",
                    style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                  Text(
                    "$date",
                    style: TextStyle(
                    color: pinkColor,
                    fontSize: 22,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                ],

              ),
              SizedBox(height: 10,),
              Row(
                
                children: [
                  Icon(
                      Icons.schedule,
                      color: Colors.black,
                      size: 23,
                    ),
                    SizedBox(width: 10,),
                  
                  Text(
                    "Time: ",
                    style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                  Text(
                    "$time",
                    style: TextStyle(
                    color: pinkColor,
                    fontSize: 22,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                ],

              ),
              
              SizedBox(height: 15,),
              Row(
                children: [
                  Icon(
                    Icons.repeat,
                    color: Colors.black,
                    size: 23,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "Repeat: ",
                    style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                  Container(
                    child: buildRepeatWidget(repeat),
                  ),
                ],

              ),

          ],),
        

        

        );
      }

      else{
        return Container(
          child: Text('Reminder Not Found', 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
              letterSpacing: -0.28,),
            )
        );
      }
      
    
  }
  
  String reminderId ='';
  @override
  Widget build(BuildContext context) {
    reminderId =ModalRoute.of(context)?.settings.arguments as String;
    
    return Scaffold(
      backgroundColor: backGroundPink,

      body: Column(
        children: [
          SizedBox(
              height: 40,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 20,),
                Text(
                  "Reminder Details",
                  style: TextStyle(
                    color: Color(0xFFD77D7C),
                    fontSize: 32,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ), 

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 0.0,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50.0),
                  ),
              ),

              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    SizedBox(height: 25,),
                    
                    FutureBuilder<Widget>(
                      future: reminderInfo(reminderId), 
                      builder: (BuildContext context , AsyncSnapshot<Widget> snapshot){
                        if(snapshot.hasData) {
                          return snapshot.data!;
                        }
                        
                      return 
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 100,vertical: 250),
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(color: pinkColor, strokeWidth: 3,)),
                        );
                        
                      },
                    ),
                   
                
                ],
                ),
              )  
              
            ),
          ),

        ],
      ),

    );
  }

}

