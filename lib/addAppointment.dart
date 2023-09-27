// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, unused_field, unnecessary_const, unnecessary_new, prefer_final_fields, unused_element, avoid_print, no_leading_underscores_for_local_identifiers, file_names, unused_local_variable, unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'colors.dart';
import 'package:jiffy/jiffy.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:http/http.dart' as http;

class addAppointment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _addAppointmentState();
  }
}

class _addAppointmentState extends State<addAppointment> {
  DateTime date = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  var startFormat = Jiffy.now().format(pattern: "hh:mm a");
  var endFormat = Jiffy.now().format(pattern: "hh:mm a");

  static const _scopes = const [
    CalendarApi.calendarScope
  ]; //scope to CREATE EVENT in calendar
  var _clientID = new ClientId(
      "3982098128-rlts9furpv5as6ob6885ifd4l88760pa.apps.googleusercontent.com",
      ""); //ClientID Object

  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: _scopes,
  );

  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';

  // @override
  // void initState() {
  //   super.initState();

  //   _googleSignIn.onCurrentUserChanged
  //       .listen((GoogleSignInAccount? account) async {
  //     // In mobile, being authenticated means being authorized...
  //     bool isAuthorized = account != null;
  //     // However, in the web...
  //     if (kIsWeb && account != null) {
  //       isAuthorized = await _googleSignIn.canAccessScopes(_scopes);
  //     }

  //     setState(() {
  //       _currentUser = account;
  //       _isAuthorized = isAuthorized;
  //     });

  //     // Now that we know that the user can access the required scopes, the app
  //     // can call the REST API.
  //     if (isAuthorized) {
  //       unawaited(_handleGetContact(account!));
  //     }
  //   });

  //   // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
  //   //
  //   // It is recommended by Google Identity Services to render both the One Tap UX
  //   // and the Google Sign In button together to "reduce friction and improve
  //   // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
  //   _googleSignIn.signInSilently();
  // }
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      // if (_currentUser != null) {
      //   _handleGetContact();
      // }
    });
    _googleSignIn.signInSilently();
  }

  // final GoogleSignIn _googleSignInwithClientID = GoogleSignIn(
  //     clientId:
  //         "3982098128-rlts9furpv5as6ob6885ifd4l88760pa.apps.googleusercontent.com",
  //     scopes: _scopes);

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleAuthorizeScopes() async {
    final bool isAuthorized = await _googleSignIn.requestScopes(_scopes);
    setState(() {
      _isAuthorized = isAuthorized;
    });
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  insertEvent(event) async {
    // final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    // final httpClient = (await googleUser?.authHeaders);
    // final googleAPI.CalendarApi calendarAPI = googleAPI.CalendarApi(httpClient);
    // final googleAPI.Events calEvents = await calendarAPI.events.list(
    //   "primary",
    // );
    final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
    assert(client != null, 'Authenticated client missing!');

    print('HELLO');
    // var client = (await _googleSignIn.authenticatedClient())!;
    print(client);
    print("printed client");
    // assert(client != null, 'Authenticated client missing!');
    final CalendarApi googleCalendarApi = CalendarApi(client!);
    try {
      // clientViaUserConsent(
      //   _clientID,
      //   _scopes,
      //   prompt,
      // ).then((AuthClient client) {
      //   var calendar = CalendarApi(client);
      String calendarId = "primary";
      googleCalendarApi.events.insert(event, calendarId).then((value) {
        print("ADDEDD_________________${value.status}");
        if (value.status == "confirmed") {
          print('Event added in google calendar');
        } else {
          print("Unable to add event in google calendar");
        }
      });
      // });
    } catch (e) {
      print('Error creating event $e');
    }
  }

  void prompt(String url) async {
    // if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
    // } else {
    throw 'Could not launch $url';
    // }
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _apptNameKey = GlobalKey<FormFieldState>();
  final TextEditingController _apptNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _showDialog(Widget child) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system
          // navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backGroundPink,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          SizedBox(
            height: 55,
          ),
          Text(
            "Add a new appointment",
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
            height: 20,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 0.0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(80.0),
                ),
              ),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                //Appointment name label
                                margin: EdgeInsets.only(top: 30, left: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Appointment Name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 20,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w700,
                                    height: 1.30,
                                    letterSpacing: -0.28,
                                  ),
                                ),
                              ),
                              Padding(
                                //baby name text field
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: TextFormField(
                                  key: _apptNameKey,
                                  controller: _apptNameController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 15),
                                    focusedErrorBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 0.50,
                                        color: Color.fromRGBO(255, 100, 100, 1),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 0.50,
                                        color: Color.fromRGBO(255, 100, 100, 1),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 0.50,
                                        color:
                                            Color.fromARGB(255, 221, 225, 232),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // gapPadding: 100,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 0.50,
                                        color:
                                            Color.fromARGB(255, 221, 225, 232),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFF7F8F9),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This field cannot be empty.";
                                    }
                                    if (!RegExp(r'^[a-z A-Z0-9]+$')
                                        .hasMatch(value)) {
                                      //allow alphanumerical only AND SPACE
                                      return "Please Enter letters only";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ), //end of appointment name text field
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 30),
                                child: _DatePickerItem(
                                  children: <Widget>[
                                    const Text(
                                      'Date',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 20,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        height: 1.30,
                                        letterSpacing: -0.28,
                                      ),
                                    ),
                                    CupertinoButton(
                                      // Display a CupertinoDatePicker in date picker mode.
                                      onPressed: () => _showDialog(
                                        CupertinoDatePicker(
                                          initialDateTime: date,
                                          mode: CupertinoDatePickerMode.date,
                                          use24hFormat: false,
                                          // This shows day of week alongside day of month
                                          showDayOfWeek: true,
                                          // This is called when the user changes the date.
                                          onDateTimeChanged:
                                              (DateTime newDate) {
                                            setState(() => date = newDate);
                                          },
                                        ),
                                      ),
                                      // In this example, the date is formatted manually. You can
                                      // use the intl package to format the value based on the
                                      // user's locale settings.
                                      child: Text(
                                        '${date.month}-${date.day}-${date.year}',
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                          color: Color(0xFFD77D7C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 30),
                                child: _DatePickerItem(
                                  children: <Widget>[
                                    const Text(
                                      'Starting Time',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 20,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        height: 1.30,
                                        letterSpacing: -0.28,
                                      ),
                                    ),
                                    CupertinoButton(
                                      // Display a CupertinoDatePicker in time picker mode.
                                      onPressed: () => _showDialog(
                                        CupertinoDatePicker(
                                          initialDateTime: startTime,
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: false,
                                          // This is called when the user changes the time.
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(() => startTime = newTime);
                                            print(newTime.toString());
                                            var jiffy =
                                                Jiffy.parse(newTime.toString());
                                            startFormat = jiffy.format(
                                                pattern: "hh:mm a");
                                            print(startFormat);
                                          },
                                        ),
                                      ),
                                      // In this example, the time value is formatted manually.
                                      // You can use the intl package to format the value based on
                                      // the user's locale settings.
                                      child: Text(
                                        startFormat,
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                          color: Color(0xFFD77D7C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 30),
                                child: _DatePickerItem(
                                  children: <Widget>[
                                    const Text(
                                      'End Time',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 20,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        height: 1.30,
                                        letterSpacing: -0.28,
                                      ),
                                    ),
                                    CupertinoButton(
                                      // Display a CupertinoDatePicker in time picker mode.
                                      onPressed: () => _showDialog(
                                        CupertinoDatePicker(
                                          initialDateTime: startTime,
                                          mode: CupertinoDatePickerMode.time,
                                          use24hFormat: false,
                                          // This is called when the user changes the time.
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(() => endTime = newTime);
                                            print(newTime.toString());
                                            var jiffy =
                                                Jiffy.parse(newTime.toString());
                                            endFormat = jiffy.format(
                                                pattern: "hh:mm a");
                                            print(startFormat);
                                          },
                                        ),
                                      ),
                                      // In this example, the time value is formatted manually.
                                      // You can use the intl package to format the value based on
                                      // the user's locale settings.
                                      child: Text(
                                        endFormat,
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                          color: Color(0xFFD77D7C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                //start journey button
                                padding: const EdgeInsets.only(top: 30.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _handleSignIn();
                                    Event event =
                                        Event(); // Create object of event
                                    event.summary = _apptNameController
                                        .text; //Setting summary of object (name of event)

                                    EventDateTime start = new EventDateTime();
                                    // start.date = date; //setting start time
                                    start.dateTime = startTime;
                                    start.timeZone = DateTime.now()
                                        .timeZoneName; //local timezone
                                    event.start = EventDateTime(
                                        // date: date,
                                        dateTime: DateTime(
                                            date.year,
                                            date.month,
                                            date.day,
                                            startTime.hour,
                                            startTime.minute,
                                            startTime.second),
                                        timeZone: DateTime.now().timeZoneName);
                                    // event.start!.date = date;

                                    EventDateTime end = new EventDateTime();
                                    // end.date = date; //setting end time
                                    end.timeZone = DateTime.now()
                                        .timeZoneName; //local timezone
                                    end.dateTime = endTime;
                                    event.end = EventDateTime(
                                        // date: date,
                                        dateTime: DateTime(
                                            date.year,
                                            date.month,
                                            date.day,
                                            endTime.hour,
                                            endTime.minute,
                                            endTime.second),
                                        timeZone: DateTime.now().timeZoneName);
                                    // event.end!.date = date;

                                    insertEvent(event);
                                  }, //end onPressed()
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: blackColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    padding: EdgeInsets.only(
                                        left: 85,
                                        top: 15,
                                        right: 85,
                                        bottom: 15),
                                  ),
                                  child: Text(
                                    "Add Appointment",
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
