// ignore_for_file: use_key_in_widget_constructors, camel_case_types, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:preggo/EditPregnancyInfo.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';



class BabyInformation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
   
    return _babyInformation();
  }
}

class _babyInformation extends State<BabyInformation>{
  
  String? ended;
  String pregnancyId = ''; 

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    pregnancyId = ModalRoute.of(context)?.settings.arguments as String;
    print('-----------------------$pregnancyId---------------------------------');
    ended = await checkPregnancyEnded(pregnancyId);
  }

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  //CHECKS IF THE GIVEN PREGNANCY ID IS ENDED OR NOT 
  Future<String?> checkPregnancyEnded(String pregnancyId) async {
    String userId = getUserId();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionPath = 'users/$userId/pregnancyInfo';

    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection(collectionPath).doc(pregnancyId).get();

      if (documentSnapshot.exists) {
        String endedValue = documentSnapshot.get('ended');
        return endedValue;
      }
      
    } catch (e) {
      print('Error: $e');
    }
    return 'false';
}

  //GETS BABY INFO BASED ON PREGNANCY ENDED OR NOT 
  Future<Widget> getBabyInfo (String pregnancyId) async {
    
    String userUid = getUserId();
    DocumentSnapshot babyInfo = await FirebaseFirestore.instance
    .collection('users').doc(userUid)
    .collection('pregnancyInfo')
    .doc(pregnancyId)
    .get();

    print('-------------------------$ended----------------------');
    if (ended =="false"){
      if(babyInfo.exists){

        Map<String,dynamic> data =babyInfo.data() as Map<String,dynamic>;
        var name = data['Baby\'s name'];
        var gender= data['Gender'];
        var duedate = data['DueDate'];
        String babyDueDate = duedate.toDate().toString();
        DateTime dateTime = DateTime.parse(babyDueDate);
        String formattedDate = DateFormat("yyyy/MM/dd").format(dateTime);
        String formattedTime = DateFormat("hh:mm a").format(dateTime);

        babyDueDate = formattedDate;
        String babyDueTime = formattedTime;

        String imagePath = '';
        if (gender == 'Boy') {
          imagePath = 'assets/images/babydetails.png';
        } else if (gender == 'Girl') {
          imagePath = 'assets/images/babygirl.png';
        } 
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Image.asset(
                      imagePath,
                      height: 35,
                      width: 35,
                    ),
                  ),
                    SizedBox(width: 10,),
                  Text(
                    "Name: ",
                    style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                  Text(
                    "$name",
                    style: TextStyle(
                    color: pinkColor,
                    fontSize: 21,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                ],

              ),
              SizedBox(height: 23,),
              
              Row(
                
                children: [
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Image.asset(
                      'assets/images/gender.png',
                      height: 35,
                      width: 35,
                    ),
                  ),
                    SizedBox(width: 10,),
                  
                  Text(
                    "Gender: ",
                    style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                  Text(
                    "$gender",
                    style: TextStyle(
                    color: pinkColor,
                    fontSize: 21,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                ],

              ),
              SizedBox(height: 23,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Image.asset(
                      'assets/images/duedate.png',
                      height: 32,
                      width: 32,
                    ),
                  ),
                  SizedBox(width: 13,),
                  
                  Text(
                    "DueDate: ",
                    style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        babyDueDate,
                        style: TextStyle(
                        color: pinkColor,
                        fontSize: 21,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                        height: 1.30,
                        letterSpacing: -0.28,
                        ),
                      ),
                      Text(
                        babyDueTime,
                        style: TextStyle(
                        color: pinkColor,
                        fontSize: 21,
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

          ],),
        
        );

      }
      else{
        return Center(
          child: Column(
            children: [
              Center(
                //no info image
                child: Padding(
                  padding: EdgeInsets.only(top: 120),
                  child: Image.asset(
                    'assets/images/empty.png',
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
              Container(
                  //message
                  margin: EdgeInsets.fromLTRB(30, 35, 30, 80),
                  child: Text(
                    'No Baby Information',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.28,
                    ),
                  )),
            ],
          ),
        );
        
      }
      
    }

    else{
      if(babyInfo.exists){
        return Container(
          child: Text('Baby Information Not Found', 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
              letterSpacing: -0.28,),
            )
        );
      }
      else{
        return Container(
          child: Text('Baby Information Not Found', 
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
  }
  
  
  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      backgroundColor: backGroundPink,

      body: Stack(
        children: [
        Column(
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
                  SizedBox(width: 10,),
                  Text(
                    "Baby's Information",
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
                        future: getBabyInfo(pregnancyId), 
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

        Align(
          alignment: Alignment.bottomCenter,
          child: 
          Padding(
            padding: EdgeInsets.only(bottom: 65),
            child: ElevatedButton(
              onPressed: () { //change later to route to edit reminder page 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => editPregnancyInfo(),
                    settings: RouteSettings(arguments: pregnancyId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blackColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(45)),
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15)
              ),
              child: const Text(
                "Edit Baby's Information",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  height: 1.30,
                  letterSpacing: -0.28,
                ),
              ),
            ),
          ),
        ),
        ],
      ),

    );
  }

}