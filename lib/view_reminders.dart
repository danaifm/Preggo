// ignore_for_file: file_names, use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_init_to_null, unused_import, avoid_print, unused_element

import 'package:flutter/material.dart';
import 'package:googleapis/compute/v1.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';


class viewReminders extends StatefulWidget {
  //const SignUp({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _viewReminders();
  }
}

class _viewReminders extends State<viewReminders> {
  late final String userId;
  late String formattedDate = ""; 
  

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  Future<Container> getReminders(String reminderDate) async {

    //FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userUid = getUserId();

    QuerySnapshot result = await FirebaseFirestore.instance
    .collection('users').doc(userUid)
    .collection('reminders')
    .where('date', isEqualTo: reminderDate)
    .get();
    
    if(result.docs.isEmpty)
    {
      return Container(child: Text('nothing here $reminderDate', style: TextStyle(fontSize: 20),));
    }
    else{
    return Container(child: Text('reminders are here!$reminderDate', style: TextStyle(fontSize: 20)));
    }

  }

  
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backGroundPink,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              "Reminders",
              style: TextStyle(
                color: Color(0xFFD77D7C),
                fontSize: 32,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                height: 1.30,
                letterSpacing: -0.28,
              ),
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
                    top: Radius.circular(45.0),
                  ),
                ),

                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 10),
                
                  child:

                    Container(

                      
                      child:Column(
                        children: [
                          EasyDateTimeLine(
                            initialDate: DateTime.now(),
                            onDateChange: (selectedDate) { 
                              var dateOnly = selectedDate.toString();
                              dateOnly= dateOnly.substring(0,10);
                              List dateComponents = dateOnly.split("-"); 
                              int year = int.parse(dateComponents[0]); 
                              int month = int.parse(dateComponents[1]); 
                              int day = int.parse(dateComponents[2]); 
                              formattedDate = "${month.toStringAsFixed(0)}-${day.toStringAsFixed(0)}-$year"; 
                              
                            },
                            activeColor: pinkColor,
                            headerProps: const EasyHeaderProps(
                            monthPickerType: MonthPickerType.dropDown,
                            selectedDateFormat: SelectedDateFormat.fullDateDMonthAsStrY,
                          ),
                                          
                            dayProps: const EasyDayProps(
                            activeDayStyle: DayStyle(
                              borderRadius: 12.0,
                            ),
                            inactiveDayStyle: DayStyle(
                              borderRadius: 12.0,
                            ),
                            todayHighlightStyle: TodayHighlightStyle.withBorder,
                                      
                          ),
                            timeLineProps: const EasyTimeLineProps(
                            hPadding: 16.0, // padding from left and right
                            separatorPadding: 16.0, // padding between days
                            ),
                          ),

                          

                          FutureBuilder<Widget>(
                            future: getReminders(formattedDate), 
                            builder: (BuildContext context , AsyncSnapshot<Widget> snapshot){
                              if(snapshot.hasData) {
                                return snapshot.data!;
                              }
                              
                            return Container(child: CircularProgressIndicator(),);
                            },
                            )

                            
                          
                        ],
                      ),
                    ),

                    
                  ),
                
                ),
              ),
            
            

            
            

            
          ],
        ));
  }
}