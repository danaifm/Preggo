// ignore_for_file: use_key_in_widget_constructors, camel_case_types, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:preggo/screens/edit_reminder.dart';
import 'package:preggo/view_reminders.dart';

class reminderDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _reminderDetails();
  }
}

class _reminderDetails extends State<reminderDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      reminderId = ModalRoute.of(context)?.settings.arguments as String;
      print("Reminder Id:: $reminderId ##");
      await fetchReminderDetailsByReminderId();
    });
  }

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  Widget getDayWidget(String id, String short) {
    String fullName = "";
    if (short == "Sun") {
      fullName = "Sunday";
    } else if (short == "Mon") {
      fullName = "Monday";
    } else if (short == "Tue") {
      fullName = "Tuesday";
    } else if (short == "Wed") {
      fullName = "Wednesday";
    } else if (short == "Thu") {
      fullName = "Thursday";
    } else if (short == "Fri") {
      fullName = "Friday";
    } else if (short == "Sat") {
      fullName = "Saturday";
    }

    return Column(
      children: [
        Container(
          width: 130,
          height: 30,
          decoration: BoxDecoration(
            color: backGroundPink,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              "Every $fullName",
              style: TextStyle(
                color: pinkColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 3,
        ),
      ],
    );
  }

  Widget buildRepeatWidget(List<dynamic> repeat) {
    if (repeat.isEmpty) {
      return Text(
        "None",
        style: TextStyle(
          color: pinkColor,
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w600,
          fontSize: 21,
          height: 1.30,
          letterSpacing: -0.28,
        ),
      );
    } else {
      return Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var item in repeat)
            if (item is Map<String, dynamic>)
              getDayWidget(item["id"], item["short"]),
        ],
      );
    }
  }

  var reminderDetails = {};

  fetchReminderDetailsByReminderId() async {
    final String userUid = FirebaseAuth.instance.currentUser?.uid ?? "";
    log("User Uid:: $userUid #");
    if (userUid.isNotEmpty && reminderId.isNotEmpty) {
      final reminder = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('reminders')
          .doc(reminderId)
          .get()
          .then((value) {
        setState(() {
          log("reminder.data():: ${value.data()} ###");
          reminderDetails = value.data() as Map<String, dynamic>;
        });
      });
    }
  }

  Future<Container> reminderInfo(String reminderId) async {
    String userUid = getUserId();

    DocumentSnapshot reminder = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('reminders')
        .doc(reminderId)
        .get();

    if (reminder.exists) {
      reminderDetails = reminder.data() as Map<String, dynamic>;
      Map<String, dynamic> data = reminder.data() as Map<String, dynamic>;
      var title = data['title'];
      var time = data['time'];
      var date = data['date'];
      var repeat = data['repeat'];
      var desc = data['description'];
      if (desc.isEmpty) {
        desc = "None";
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Title: ",
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
                  "$title",
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
            SizedBox(
              height: 17,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Description: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
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
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Text(
                        "$desc",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                        softWrap: true,
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
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 17,
            ),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Date: ",
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
                  "$date",
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
            SizedBox(
              height: 17,
            ),
            Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Time: ",
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
                  "$time",
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
            SizedBox(
              height: 17,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Icon(
                  Icons.repeat_outlined,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Repeat:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 1.30,
                    letterSpacing: -0.28,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topCenter,
                        child: buildRepeatWidget(repeat)),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
          child: Text(
        'Reminder Not Found',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w600,
          letterSpacing: -0.28,
        ),
      ));
    }
  }

  String reminderId = '';
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
                  SizedBox(
                    width: 20,
                  ),
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
                          SizedBox(
                            height: 25,
                          ),
                          FutureBuilder<Widget>(
                            future: reminderInfo(reminderId),
                            builder: (BuildContext context,
                                AsyncSnapshot<Widget> snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data!;
                              }

                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 250),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      color: pinkColor,
                                      strokeWidth: 3,
                                    )),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(45, 0, 0, 65),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      try {
                        final List<Map<String, dynamic>> repeat =
                            reminderDetails['repeat']
                                as List<Map<String, dynamic>>;
                        log("Repeated days:: ${reminderDetails} #");
                      } catch (error) {
                        print("Error:: $error #");
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditReminderScreen(
                              title: reminderDetails['title'],
                              description: reminderDetails['description'],
                              date: reminderDetails['date'],
                              time: reminderDetails['time'],
                              repeated: List.from(reminderDetails['repeat']),
                              reminderId: reminderDetails['id'],
                            );
                          },
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blackColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45)),
                      padding: const EdgeInsets.only(
                          left: 53, top: 15, right: 53, bottom: 15),
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                        height: 1.30,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //change later to route to delete reminder page
                      /*Navigator.of(context)
                        .pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                        return viewReminders();
                      }),
                      (route) => false, 
                    ); */
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 200, 36, 24),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45)),
                      padding: const EdgeInsets.only(
                          left: 48, top: 15, right: 48, bottom: 15),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                        height: 1.30,
                        letterSpacing: -0.28,
                      ),
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
