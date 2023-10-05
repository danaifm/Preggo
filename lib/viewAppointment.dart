// ignore_for_file: unnecessary_const, prefer_final_fields

import 'dart:math';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:preggo/colors.dart';
import 'package:preggo/screens/ToolsPage.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_sign_in/google_sign_in.dart';

class viewAppointment extends StatefulWidget {
  //const SignUp({Key? key}) : super(key: key);
  // late final String userId;
  @override
  State<StatefulWidget> createState() {
    return _viewAppointment();
  }
}

class _viewAppointment extends State<viewAppointment> {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Text("Bdoor"),
  //   );
  // }

  //  Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SfCalendar(
  //       view: CalendarView.month,
  //       initialDisplayDate: DateTime(2023, 09, 01),
  //     ),
  //   );
  // }

  static const _scopes = const [CalendarApi.calendarScope];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId:
    //     '3982098128-rlts9furpv5as6ob6885ifd4l88760pa.apps.googleusercontent.com',
    scopes: _scopes,
  );

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signInSilently();
    } catch (error) {
      print(error);
    }
  }

  // GoogleSignInAccount? _currentUser;

  // @override
  // void initState() {
  //   super.initState();
  //   // dispose();
  //   _googleSignIn.disconnect();
  //   _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
  //     setState(() {
  //       _currentUser = account;
  //     });
  //     if (_currentUser != null) {
  //       //getGoogleEventsData();
  //     }
  //   });
  //   _googleSignIn.signInSilently();
  // }

  @override
  void initState() {
    super.initState();
    // _googleSignIn.onCurrentUserChanged
    //     .listen((GoogleSignInAccount? account) {});

    print("START OF PAGE");
    print(_googleSignIn.currentUser);
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _googleSignIn.signInSilently();
  // }

  getAppointments() async {
    print('in get appts');
    // _googleSignIn.signOut();
    print("AA first: " + (await _googleSignIn.isSignedIn()).toString());
    // await _googleSignIn.signOut();
    await _googleSignIn.signIn();
    print("AA second: " + (await _googleSignIn.isSignedIn()).toString());
    // _googleSignIn
    //     .signOut(); //this line will make it ask for your account every time
    // _googleSignIn.signIn();
    // await _handleSignIn();

    print('before await');
    final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
    //assert(client != null, 'authenticated client missing!');
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
    //push

    if (exists == false) {
      Calendar preggoCalendar = new Calendar(summary: "Preggo Calendar");
      googleCalendarApi.calendars.insert(preggoCalendar);
      for (CalendarListEntry entry in items) {
        if (entry.summary == "Preggo Calendar") {
          id = entry.id;
          break;
        }
      }
    }
    final Events calEvents = await googleCalendarApi.events.list(id!);

    final List<Event> appointments = <Event>[];
    if (calEvents.items != null) {
      for (int i = 0; i < calEvents.items!.length; i++) {
        final Event event = calEvents.items![i];
        if (event.start == null) {
          continue;
        }
        appointments.add(event);
      }
    }

    // final List<GoogleAPI.Event> appointments = <GoogleAPI.Event>[];
    // if (calEvents.items != null) {
    //   for (int i = 0; i < calEvents.items!.length; i++) {
    //     final GoogleAPI.Event event = calEvents.items![i];
    //     if (event.start == null) {
    //       continue;
    //     }
    //     appointments.add(event);
    //   }
    // }

    return appointments;
  }

  // Future<List<GoogleAPI.Event>> getGoogleEventsData() async {
  //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  //   final GoogleAPIClient httpClient =
  //       GoogleAPIClient(await googleUser!.authHeaders);

  //   final GoogleAPI.CalendarApi calendarApi = GoogleAPI.CalendarApi(httpClient);
  //   final GoogleAPI.Events calEvents = await calendarApi.events.list(
  //     "primary",
  //   );
  // }
  //   final List<GoogleAPI.Event> appointments = <GoogleAPI.Event>[];
  //   if (calEvents.items != null) {
  //     for (int i = 0; i < calEvents.items!.length; i++) {
  //       final GoogleAPI.Event event = calEvents.items![i];
  //       if (event.start == null) {
  //         continue;
  //       }
  //       appointments.add(event);
  //     }
  //   }

  //   return appointments;
  // }

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
                "Appointments",
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
                            //The design of the calender
                            view: CalendarView.month,
                            cellBorderColor: backGroundPink,
                            initialDisplayDate: DateTime.now(),
                            selectionDecoration: BoxDecoration(
                              color: transparent,
                              border:
                                  Border.all(color: backGroundPink, width: 2),
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
                            dataSource: GoogleDataSource(events: snapshot.data),
                          ),
                          snapshot.data != null
                              ? Container()
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                          //add reminder button
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 20, 80),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ToolsPage()));
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
                              ))
                        ],
                      ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   if (_googleSignIn.currentUser != null) {
  //     _googleSignIn.disconnect();
  //     _googleSignIn.signOut();
  //   }

  //   super.dispose();
  // }
}

class GoogleDataSource extends CalendarDataSource {
  GoogleDataSource({required List<Event>? events}) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    final Event event = appointments![index];
    return event.start?.date ?? event.start!.dateTime!.toLocal();
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].start.date != null;
  }

  @override
  DateTime getEndTime(int index) {
    final Event event = appointments![index];
    return event.endTimeUnspecified != null && event.endTimeUnspecified!
        ? (event.start?.date ?? event.start!.dateTime!.toLocal())
        : (event.end?.date != null
            ? event.end!.date!.add(const Duration(days: -1))
            : event.end!.dateTime!.toLocal());
  }

  @override
  String getLocation(int index) {
    return appointments![index].location ?? '';
  }

  @override
  String getNotes(int index) {
    return appointments![index].description ?? '';
  }

  @override
  String getSubject(int index) {
    final Event event = appointments![index];
    return event.summary == null || event.summary!.isEmpty
        ? 'No Title'
        : event.summary!;
  }
}

// class GoogleAPIClient extends IOClient {
//   final Map<String, String> _headers;

//   GoogleAPIClient(this._headers) : super();

//   @override
//   Future<IOStreamedResponse> send(BaseRequest request) =>
//       super.send(request..headers.addAll(_headers));

//   @override
//   Future<Response> head(Uri url, {Map<String, String>? headers}) =>
//       super.head(url,
//           headers: (headers != null ? (headers..addAll(_headers)) : headers));
// }
