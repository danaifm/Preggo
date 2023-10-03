// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, unnecessary_const, unnecessary_new, prefer_final_fields, avoid_print, no_leading_underscores_for_local_identifiers, file_names,
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preggo/screens/PregnancyTracking.dart';
import 'colors.dart';
import 'package:jiffy/jiffy.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class addAppointment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _addAppointmentState();
  }
}

class _addAppointmentState extends State<addAppointment> {
  @override
  void initState() {
    super.initState();
    _googleSignIn.signInSilently();
  }

  DateTime date = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  var startFormat = Jiffy.now().format(pattern: "hh:mm a");
  var endFormat = Jiffy.now().format(pattern: "hh:mm a");
  var errorMessage = "";
  DateTime _minDate = DateTime.now();
  DateTime _minTime = DateTime.now();

  static const _scopes = const [
    CalendarApi.calendarScope
  ]; //scope to CREATE EVENT / CALENDAR in Google calendar

  // var _clientID = new ClientId(
  //     "3982098128-rlts9furpv5as6ob6885ifd4l88760pa.apps.googleusercontent.com",
  //     ""); //ClientID Object

  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: _scopes,
  );

  insertEvent(event) async {
    final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
    assert(client != null, 'Authenticated client missing!');
    print(client);
    print("printed client");
    final CalendarApi googleCalendarApi = CalendarApi(client!);
    try {
      String? id;
      bool exists = false;
      var list = await googleCalendarApi.calendarList.list();
      var items = list.items;
      for (CalendarListEntry entry in items!) {
        print(entry.summary);
        if (entry.summary == "Preggo Calendar") {
          id = entry.id;
          exists = true;
          break;
        }
      }
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

      googleCalendarApi.events.insert(event, id!).then((value) {
        print("ADDEDD_________________${value.status}");
        if (value.status == "confirmed") {
          print('Event added in google calendar');
        } else {
          print("Unable to add event in google calendar");
        }
      });
    } catch (e) {
      print('Error creating event $e');
    }
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _apptNameKey = GlobalKey<FormFieldState>();
  final TextEditingController _apptNameController = TextEditingController();

  final GlobalKey<FormFieldState> _hospitalKey = GlobalKey<FormFieldState>();
  final TextEditingController _hospitalController = TextEditingController();

  final GlobalKey<FormFieldState> _drKey = GlobalKey<FormFieldState>();
  final TextEditingController _drController = TextEditingController();

  bool timeRed = false;
  bool valid = false;

  @override
  Widget build(BuildContext context) {
    Color timeColor =
        timeRed ? Color.fromRGBO(255, 100, 100, 1) : Color(0xFFD77D7C);

    var textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12.0,
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.normal,
        );
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
            height: 35,
          ),
          Container(
            alignment: AlignmentDirectional.centerStart,
            child: IconButton(
              onPressed: () {
                // Navigator.push(context,  MaterialPageRoute(
                //                         builder: (context) => PregnancyTracking()));
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          Text(
            "Add a new appointment",
            style: TextStyle(
              color: Color(0xFFD77D7C),
              fontSize: 30,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
              height: 1.30,
              letterSpacing: -0.28,
            ),
          ),
          SizedBox(
            height: 15,
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
                                    fontSize: 17,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w700,
                                    height: 1.30,
                                    letterSpacing: -0.28,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: TextFormField(
                                  key: _apptNameKey,
                                  controller: _apptNameController,
                                  maxLength: 25,
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This field cannot be empty.";
                                    }
                                    if (!RegExp(r'^[a-z A-Z0-9]+$')
                                        .hasMatch(value)) {
                                      //allow alphanumerical only AND SPACE
                                      return "Please enter letters only.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Container(
                                //hospital name label
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Hospital Name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 17,
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
                                    const EdgeInsets.symmetric(vertical: 0.0),
                                child: TextFormField(
                                  key: _hospitalKey,
                                  controller: _hospitalController,
                                  maxLength: 25,
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This field cannot be empty.";
                                    }
                                    if (!RegExp(r'^[a-z A-Z0-9]+$')
                                        .hasMatch(value)) {
                                      //allow alphanumerical only AND SPACE
                                      return "Please enter letters only.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ), //end of hospital name text field
                              Container(
                                //doctor name label
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Doctor's Name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 17,
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
                                    const EdgeInsets.symmetric(vertical: 0.0),
                                child: TextFormField(
                                  key: _drKey,
                                  controller: _drController,
                                  maxLength: 25,
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This field cannot be empty.";
                                    }
                                    if (!RegExp(r'^[a-z A-Z0-9]+$')
                                        .hasMatch(value)) {
                                      //allow alphanumerical only AND SPACE
                                      return "Please enter letters only.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ), //end of dr name text field
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: _DatePickerItem(
                                  children: <Widget>[
                                    const Text(
                                      'Date',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 17,
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
                                          // initialDateTime:
                                          //     date.add(Duration(seconds: 1)),
                                          initialDateTime:
                                              date.isAfter(DateTime.now())
                                                  ? date
                                                  : DateTime.now(),
                                          // minimumDate: DateTime.now(),
                                          // maximumDate: DateTime.now()
                                          //     .add(Duration(days: 3650)),
                                          minimumDate: _minDate,
                                          maximumDate: DateTime.now().copyWith(
                                            year: DateTime.now().year + 10,
                                            month: 12,
                                            day: 31,
                                          ),
                                          mode: CupertinoDatePickerMode.date,
                                          use24hFormat: false,
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
                                      child: Row(
                                        children: [
                                          Text(
                                            '${date.month}-${date.day}-${date.year}',
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Color(0xFFD77D7C),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                end: 0),
                                            child: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: blackColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   margin: EdgeInsets.only(left: 50),
                                    // ),
                                    // const Padding(
                                    //   padding:
                                    //       EdgeInsetsDirectional.only(start: 5),
                                    //   child: Icon(Icons.keyboard_arrow_down),
                                    // ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 0),
                                child: _DatePickerItem(
                                  children: <Widget>[
                                    Text(
                                      'Starting Time',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 17,
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
                                          initialDateTime:
                                              startTime.isAfter(DateTime.now())
                                                  ? startTime
                                                  : DateTime.now(),
                                          minimumDate: date.day ==
                                                      DateTime.now().day &&
                                                  date.month ==
                                                      DateTime.now().month &&
                                                  date.year ==
                                                      DateTime.now().year
                                              ? _minTime
                                              : null,
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
                                      child: Row(
                                        children: [
                                          Text(
                                            startFormat,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: timeColor,
                                              // color: Color(0xFFD77D7C),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                start: 0),
                                            child: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: blackColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 0),
                                child: _DatePickerItem(
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Text(
                                          'End Time',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 17,
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w700,
                                            height: 1.30,
                                            letterSpacing: -0.28,
                                          ),
                                        ),
                                      ],
                                    ),
                                    CupertinoButton(
                                      // Display a CupertinoDatePicker in time picker mode.
                                      onPressed: () => _showDialog(
                                        CupertinoDatePicker(
                                          initialDateTime:
                                              endTime.isAfter(DateTime.now())
                                                  ? endTime
                                                  : DateTime.now(),
                                          minimumDate: date.day ==
                                                      DateTime.now().day &&
                                                  date.month ==
                                                      DateTime.now().month &&
                                                  date.year ==
                                                      DateTime.now().year
                                              ? _minTime
                                              : null,
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
                                      child: Row(
                                        children: [
                                          Text(
                                            endFormat,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: timeColor,
                                              // color: Color(0xFFD77D7C),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                end: 0),
                                            child: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: blackColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 5),
                                child: Text(errorMessage, style: textStyle),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (startTime.isAfter(endTime)) {
                                      setState(() {
                                        errorMessage =
                                            "Starting time cannot be after end time.";
                                        valid = false;
                                        timeRed = true;
                                      });
                                    } else if (startTime.hour == endTime.hour &&
                                        startTime.minute == endTime.minute) {
                                      setState(() {
                                        errorMessage =
                                            "Starting time cannot be equal to end time.";
                                        valid = false;
                                        timeRed = true;
                                      });
                                    } else if (_apptNameController
                                        .text.isEmpty) {
                                      errorMessage = "";
                                      valid = false;
                                      timeRed = false;
                                      print("not added because empty name");
                                    } else {
                                      setState(() {
                                        timeRed = false;
                                        errorMessage = "";
                                        // _handleSignIn();
                                        valid = true;
                                      });
                                      if (valid == true) {
                                        print("now signed in");
                                        Event event =
                                            Event(); // Create object of event
                                        event.summary = _apptNameController.text
                                            .trim(); //Setting summary of object (name of event)
                                        event.location =
                                            _hospitalController.text.trim();
                                        event.description =
                                            _drController.text.trim();

                                        EventDateTime start =
                                            new EventDateTime();
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
                                            timeZone:
                                                DateTime.now().timeZoneName);
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
                                            timeZone:
                                                DateTime.now().timeZoneName);
                                        // event.end!.date = date;

                                        insertEvent(event);
                                        print('now event inserted');
                                      }
                                    } //if valid then submit
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
