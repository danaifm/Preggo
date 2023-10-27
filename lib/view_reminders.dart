// ignore_for_file: file_names, use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_init_to_null, unused_import, avoid_print, unused_element

import 'package:flutter/material.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/main.dart';
import 'package:preggo/reminder_details.dart';
import 'package:preggo/screens/add_reminder_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart';

class viewReminders extends StatefulWidget {
  //const SignUp({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _viewReminders();
  }
}

class _viewReminders extends State<viewReminders> {
  late final String userId;
  int weekDay = 0;
  int dayInDB = 0;
  String dayOfWeek = "";
  String dayShortName = "";
  String todayMonth = DateTime.now().month.toString();
  String todayDay = DateTime.now().day.toString();
  String todayYear = DateTime.now().year.toString();
  String formattedDate =
      '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}';
  // "${month.toStringAsFixed(0)}-${day.toStringAsFixed(0)}-$year";

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  Future<Widget> getReminders(
      String reminderDate, String dayOfWeek, String dayShortName) async {
    //FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userUid = getUserId();
    print('Reminder date is $reminderDate');
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('reminders')
        //.where('repeat', arrayContains: {'id': dayOfWeek})
        .where(Filter.or(
            Filter('date', isEqualTo: reminderDate),
            Filter('repeat',
                arrayContains: {'id': dayOfWeek, 'short': dayShortName})))
        .get();
    print(result.docs.length);
    print('printed');
    if (result.docs.isEmpty) //no reminders for this date
    {
      return Container(
        child: Column(
          children: [
            Center(
              //notification bell image
              child: Padding(
                padding: EdgeInsets.only(top: 120),
                child: Image.asset(
                  'assets/images/noReminder.png',
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Container(
                //message
                margin: EdgeInsets.fromLTRB(30, 35, 30, 80),
                child: Text(
                  'No Reminders',
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
    } else {
      //reminders exist for this day
      List reminderResult = result.docs;
      //sort the reminders based on the time of the day first
      reminderResult.sort((a, b) {
        String timeA = a.data()['time'] ?? '';
        String timeB = b.data()['time'] ?? '';
        // Convert 'time' strings to DateTime objects for comparison
        DateFormat format = DateFormat("hh:mm a");
        DateTime dateTimeA = format.parse(timeA);
        DateTime dateTimeB = format.parse(timeB);
        return dateTimeA.compareTo(dateTimeB);
      });

      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          height: 505,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: reminderResult.length,
            itemBuilder: (context, index) {
              String id = reminderResult[index].data()['id'] ?? '';
              String title = reminderResult[index].data()['title'] ?? '';
              String time = reminderResult[index].data()['time'] ?? '';

              return Container(
                margin: EdgeInsets.all(8),
                //padding: EdgeInsets.all(10),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 17),
                      decoration: BoxDecoration(
                        color: backGroundPink.withOpacity(0.3),
                        border: Border.all(color: backGroundPink, width: 2),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(children: [
                        Container(
                          width: 85,
                          child: Text(
                            '$time',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            '$title',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            String documentId = id;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => reminderDetails(),
                                settings: RouteSettings(arguments: documentId),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backGroundPink,
        resizeToAvoidBottomInset: true,
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
                      width: 60,
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
                        top: Radius.circular(45.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 15),
                      child: Container(
                        child: Column(
                          children: [
                            EasyDateTimeLine(
                              initialDate: DateTime.now(),
                              onDateChange: (selectedDate) {
                                setState(() {
                                  var dateOnly = selectedDate.toString();
                                  dateOnly = dateOnly.substring(0, 10);
                                  List dateComponents = dateOnly.split("-");
                                  int year = int.parse(dateComponents[0]);
                                  int month = int.parse(dateComponents[1]);
                                  int day = int.parse(dateComponents[2]);
                                  formattedDate =
                                      "${month.toStringAsFixed(0)}-${day.toStringAsFixed(0)}-$year";

                                  weekDay = selectedDate.weekday; //monday is 1
                                  if (weekDay == 1) {
                                    //monday
                                    dayInDB = 2;
                                    dayShortName = "Mon";
                                  } else if (weekDay == 2) {
                                    //tuesday
                                    dayInDB = 3;
                                    dayShortName = "Tue";
                                  } else if (weekDay == 3) {
                                    //wednesday
                                    dayInDB = 4;
                                    dayShortName = "Wed";
                                  } else if (weekDay == 4) {
                                    //thursday
                                    dayInDB = 5;
                                    dayShortName = "Thu";
                                  } else if (weekDay == 5) {
                                    //friday
                                    dayInDB = 6;
                                    dayShortName = "Fri";
                                  } else if (weekDay == 6) {
                                    //saturday
                                    dayInDB = 7;
                                    dayShortName = "Sat";
                                  } else {
                                    //sunday
                                    dayInDB = 1;
                                    dayShortName = "Sun";
                                  }

                                  dayOfWeek = dayInDB.toString();
                                });
                              },
                              activeColor: pinkColor,
                              headerProps: const EasyHeaderProps(
                                monthPickerType: MonthPickerType.dropDown,
                                selectedDateFormat:
                                    SelectedDateFormat.fullDateDMonthAsStrY,
                              ),
                              dayProps: const EasyDayProps(
                                activeDayStyle: DayStyle(
                                  borderRadius: 12.0,
                                ),
                                inactiveDayStyle: DayStyle(
                                  borderRadius: 12.0,
                                ),
                                todayHighlightStyle:
                                    TodayHighlightStyle.withBorder,
                              ),
                              timeLineProps: const EasyTimeLineProps(
                                hPadding: 16.0, // padding from left and right
                                separatorPadding: 16.0, // padding between days
                              ),
                            ),
                            FutureBuilder<Widget>(
                              future: getReminders(
                                  formattedDate, dayOfWeek, dayShortName),
                              builder: (BuildContext context,
                                  AsyncSnapshot<Widget> snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data!;
                                }

                                return CircularProgressIndicator(
                                    color: pinkColor);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 20, 50),
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AddReminderScreen())).then((value) {
                      getReminders(formattedDate, dayOfWeek, dayShortName);
                      setState(() {});
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(55, 55),
                    shape: const CircleBorder(),
                    backgroundColor: darkBlackColor,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
