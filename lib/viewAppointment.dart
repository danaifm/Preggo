// ignore_for_file: unnecessary_const, prefer_final_fields, prefer_const_constructors, avoid_print, camel_case_types, unused_element, prefer_const_literals_to_create_immutables

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:preggo/colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'addAppointment.dart';

class viewAppointment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _viewAppointment();
  }
}

class _viewAppointment extends State<viewAppointment> {
  static const _scopes = const [CalendarApi.calendarScope];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: _scopes,
  );

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signInSilently();
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    print("START OF PAGE");
    print(_googleSignIn.currentUser);
  }

  String? _subjectText = '', //appointment name
      _startTimeText = '', //start time
      _endTimeText = '', //end time
      _dateText = '', //date
      _hospitalText = '', //hospital
      _drText = ''; //dr name

  getAppointments() async {
    print('in get appts');
    // _googleSignIn.signOut();
    print("AA first: ${await _googleSignIn.isSignedIn()}");
    // await _googleSignIn.signOut();
    await _googleSignIn.signIn();
    while (await _googleSignIn.isSignedIn() == false) {
      await _googleSignIn.signIn();
    } //mandatory to log in with google!!
    print("AA second: ${await _googleSignIn.isSignedIn()}");
    print('before await');
    final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
    print(client);
    final CalendarApi googleCalendarApi = CalendarApi(client!);
    print('after googleapicalendar');
    String? id;
    bool exists = false;
    var list = await googleCalendarApi.calendarList.list();
    var items = list.items;
    for (CalendarListEntry entry in items!) {
      if (entry.summary == "Preggo Calendar") {
        id = entry.id;
        exists = true;
        break;
      }
    }

    if (exists == false) {
      Calendar preggoCalendar = Calendar(summary: "Preggo Calendar");
      googleCalendarApi.calendars.insert(preggoCalendar);
      for (CalendarListEntry entry in items) {
        if (entry.summary == "Preggo Calendar") {
          id = entry.id;
          break;
        }
      }
    }
    final Events calEvents = await googleCalendarApi.events.list(id!);

    // final List<Event> appointments = <Event>[]; >>>straight out of google calendar (may be useful for future sprints)
    List<Appointment> appts = <Appointment>[];
    if (calEvents.items != null) {
      for (int i = 0; i < calEvents.items!.length; i++) {
        final Event event = calEvents.items![i];
        if (event.start == null) {
          continue;
        }
        Appointment appt = Appointment(
            startTime: event.start!.dateTime!.toLocal(),
            endTime: event.end!.dateTime!.toLocal(),
            subject: event.summary!,
            location: event.location, //hospital
            notes: event.description, //dr name
            color: pinkColor);
        // appointments.add(event); >>>same thing
        appts.add(appt);
      }
    }
    return appts;
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Appointment appointmentDetails = details.appointments![0];

      _subjectText = appointmentDetails.subject;

      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.startTime)
          .toString();

      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.startTime).toString();

      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.endTime).toString();

      _hospitalText = appointmentDetails.location;

      _drText = appointmentDetails.notes;

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              titlePadding: EdgeInsets.all(0),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              title: Container(
                height: 45,
                color: backGroundPink,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Center(
                      child: Text(
                        'Appointment Details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              content: SizedBox(
                height: 230,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, top: 5),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Name: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$_subjectText',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Date: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$_dateText',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Start Time: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$_startTimeText',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'End Time: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$_endTimeText',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Hospital: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$_hospitalText',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Doctor: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$_drText',
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 45.0,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blackColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                padding: const EdgeInsets.only(
                                    left: 37, top: 15, right: 37, bottom: 15),
                              ),
                              child: const Text(
                                "Edit",
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 45.0,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                padding: const EdgeInsets.only(
                                    left: 30, top: 15, right: 30, bottom: 15),
                              ),
                              child: const Text(
                                "Delete",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // actions: <Widget>[
              //   TextButton(
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //       },
              //       child: new Text('close'))
              // ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  color: blackColor,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "  Appointments",
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
                color: whiteColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(80.0),
                ),
              ),
              // the end for the top decoration

              child: FutureBuilder(
                future: getAppointments(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print("in future builder");

                  return Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Stack(
                      children: [
                        SfCalendar(
                          onTap: calendarTapped,
                          //The design of the calender
                          view: CalendarView.month,
                          cellBorderColor: backGroundPink,
                          initialDisplayDate: DateTime.now(),
                          initialSelectedDate: DateTime.now(), //dana add
                          selectionDecoration: BoxDecoration(
                            color: transparent,
                            border: Border.all(color: backGroundPink, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                          ),
                          monthViewSettings: MonthViewSettings(
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.indicator,
                            showAgenda: true,
                            agendaViewHeight: 280,
                            agendaStyle: AgendaStyle(
                              appointmentTextStyle: TextStyle(
                                  fontSize:
                                      14, //the font style of the appointment info box
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor),
                              dateTextStyle: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 13, // For the circle
                                  fontWeight: FontWeight.w400,
                                  color: pinkColor),
                              dayTextStyle: TextStyle(
                                  // deign the day name
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: pinkColor),
                            ),
                            monthCellStyle: MonthCellStyle(),
                          ),
                          showNavigationArrow: true,
                          todayHighlightColor: pinkColor,

                          //End of design
                          dataSource: DataSource(snapshot.data ?? []),
                        ),
                        snapshot.hasData
                            ? Container()
                            : Center(
                                child:
                                    CircularProgressIndicator(color: pinkColor),
                              ),
                        //add reminder button
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 5, 50),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => addAppointment(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(55, 55),
                                shape: const CircleBorder(),
                                backgroundColor: darkBlackColor,
                              ),
                              child: Icon(
                                Icons.add,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleDataSource extends CalendarDataSource {
  GoogleDataSource({required List<Event>? events}) {
    appointments = events;
  }

//maybe userful for later sprints:
  // @override
  // DateTime getStartTime(int index) {
  //   final Event event = appointments![index];
  //   return event.start?.date ?? event.start!.dateTime!.toLocal();
  // }

  // @override
  // bool isAllDay(int index) {
  //   return appointments![index].start.date != null;
  // }

  // @override
  // DateTime getEndTime(int index) {
  //   final Event event = appointments![index];
  //   return event.endTimeUnspecified != null && event.endTimeUnspecified!
  //       ? (event.start?.date ?? event.start!.dateTime!.toLocal())
  //       : (event.end?.date != null
  //           ? event.end!.date!.add(const Duration(days: -1))
  //           : event.end!.dateTime!.toLocal());
  // }

  // @override
  // String getLocation(int index) {
  //   return appointments![index].location ?? '';
  // }

  // @override
  // String getNotes(int index) {
  //   return appointments![index].description ?? '';
  // }

  // @override
  // String getSubject(int index) {
  //   final Event event = appointments![index];
  //   return event.summary == null || event.summary!.isEmpty
  //       ? 'No Title'
  //       : event.summary!;
  // }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}
