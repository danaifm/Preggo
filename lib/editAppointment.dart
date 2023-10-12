// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, unnecessary_const, unnecessary_new, prefer_final_fields, avoid_print, no_leading_underscores_for_local_identifiers, file_names,
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:jiffy/jiffy.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class editAppointment extends StatefulWidget {
  final String eventID;
  editAppointment(this.eventID);
  @override
  State<StatefulWidget> createState() {
    return _editAppointment();
  }
}

class _editAppointment extends State<editAppointment> {
  // late String apptName, hospitalName, drName;
  // late DateTime apptDate, apptStart, apptEnd;
  late String receivedid;

  @override
  void initState() {
    // String idwithArgument =
    //     ModalRoute.of(context)?.settings.arguments as String;
    super.initState();
    print("INIT STATE OF EDIT APPT WITH ID ${widget.eventID}");
    // futureEvent = getEventObjectFromGoogle(widget.eventID);
    receivedid = widget.eventID;
    // print('EVENT TO BE EDITED IS $futureEvent');
    // print('IS EVENT NULL? ${futureEvent.isNull}');
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
  DateTime today = DateTime.now();

  static const _scopes = const [
    CalendarApi.calendarScope
  ]; //scope to CREATE EVENT / CALENDAR in Google calendar

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: _scopes,
  );

  Future<Event> getEventObjectFromGoogle(eventID) async {
    String? Calendarid = '';
    final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
    final CalendarApi googleCalendarApi = CalendarApi(client!);

    var list = await googleCalendarApi.calendarList.list();
    var items = list.items;
    for (CalendarListEntry entry in items!) {
      if (entry.summary == "Preggo Calendar") {
        Calendarid = entry.id;
        break;
      }
    }
    return googleCalendarApi.events.get(Calendarid!, eventID);
  }

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

//SUCCESS POPUP
      /// Show dialog | start of message
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.40,
                  width: MediaQuery.sizeOf(context).width * 0.85,
                  child: Dialog(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: green,
                                //color: pinkColor,
                                // border: Border.all(
                                //   width: 1.3,
                                //   color: Colors.black,
                                // ),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Color.fromRGBO(255, 255, 255, 1),
                                size: 35,
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Done
                            const Text(
                              "Appointment added successfully!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 17,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w700,
                                height: 1.30,
                                letterSpacing: -0.28,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// OK Button
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery.sizeOf(context).width * 0.80,
                              height: 45.0,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: blackColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    padding: const EdgeInsets.only(
                                        left: 70,
                                        top: 15,
                                        right: 70,
                                        bottom: 15),
                                  ),
                                  child: const Text(
                                    "OK",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
      }
      // Show dialog | end of message
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

  String eventID = '';
  bool timeRed = false;
  bool valid = false;

  @override
  Widget build(BuildContext context) {
    Future<Event> futureEvent = getEventObjectFromGoogle(widget.eventID);

    Color timeColor = timeRed
        ? Theme.of(context).colorScheme.error
        : Color.fromARGB(255, 0, 0, 0);
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

    backButton() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            content: SizedBox(
              height: 130,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 30),
                      child: Text(
                        'Are you sure you want to go back?',
                        textAlign: TextAlign.center,
                      ),
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
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blackColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              padding: const EdgeInsets.only(
                                  left: 30, top: 15, right: 30, bottom: 15),
                            ),
                            child: const Text(
                              "No",
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        height: 45.0,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              padding: const EdgeInsets.only(
                                  left: 30, top: 15, right: 30, bottom: 15),
                            ),
                            child: const Text(
                              "Yes",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    String newAppt = '', newHospital = '', newDr = '';

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
              onPressed: backButton,
              icon: const Icon(
                Icons.arrow_back,
                color: blackColor,
              ),
            ),
          ),
          Text(
            "Edit your appointment",
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
                  child: FutureBuilder(
                      future: futureEvent,
                      // future: getEventObjectFromGoogle(widget.eventID),
                      builder: (context, snapshot) {
                        print('IN EDIT FUTURE BUILDER');
                        print("SNAPSHOT DATA IS ${snapshot.data}");
                        if (snapshot.connectionState == ConnectionState.done) {
                          print('CONNECTION STATE DONE');
                          if (snapshot.hasData) {
                            print('SNAPSHOT HAS DATA $snapshot');
                            date = snapshot.data!.start!.dateTime!.toLocal();
                            startTime =
                                snapshot.data!.start!.dateTime!.toLocal();
                            startFormat = Jiffy.parse(startTime.toString())
                                .format(pattern: "hh:mm a");
                            endTime = snapshot.data!.end!.dateTime!.toLocal();
                            endFormat = Jiffy.parse(endTime.toString())
                                .format(pattern: "hh:mm a");
                            String hospital = snapshot.data!.location!,
                                dr = snapshot.data!.description!,
                                appt = snapshot.data!.summary!;

                            return Column(
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
                                          margin:
                                              EdgeInsets.only(top: 30, left: 5),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Appointment Name",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 17,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w700,
                                              height: 1.30,
                                              letterSpacing: -0.28,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: TextFormField(
                                            onChanged: (value) {
                                              // setState(() {
                                              newAppt = value;
                                              appt = '';
                                              // });
                                            },
                                            initialValue:
                                                snapshot.data!.summary!,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            key: _apptNameKey,
                                            //  controller: _apptNameController,
                                            maxLength: 25,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 15.0,
                                                      horizontal: 15),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                gapPadding: 0.5,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromRGBO(
                                                      255, 100, 100, 1),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                gapPadding: 0.5,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromRGBO(
                                                      255, 100, 100, 1),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                gapPadding: 0.5,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromARGB(
                                                      255, 221, 225, 232),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                // gapPadding: 100,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromARGB(
                                                      255, 221, 225, 232),
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Color(0xFFF7F8F9),
                                            ),
                                            validator: (value) {
                                              if (value!.trim().isEmpty) {
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
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 17,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w700,
                                              height: 1.30,
                                              letterSpacing: -0.28,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          //hospital name text field
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0.0),
                                          child: TextFormField(
                                            initialValue:
                                                snapshot.data!.location,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            key: _hospitalKey,
                                            // controller: _hospitalController,
                                            maxLength: 25,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 15.0,
                                                      horizontal: 15),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                gapPadding: 0.5,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromRGBO(
                                                      255, 100, 100, 1),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                gapPadding: 0.5,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromRGBO(
                                                      255, 100, 100, 1),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                gapPadding: 0.5,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromARGB(
                                                      255, 221, 225, 232),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                // gapPadding: 100,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromARGB(
                                                      255, 221, 225, 232),
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Color(0xFFF7F8F9),
                                            ),
                                            validator: (value) {
                                              if (value!.trim().isEmpty) {
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
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 17,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w700,
                                              height: 1.30,
                                              letterSpacing: -0.28,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          //dr name text field
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0.0),
                                          child: TextFormField(
                                            initialValue:
                                                snapshot.data!.description,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            key: _drKey,
                                            // controller: _drController,
                                            maxLength: 25,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 15.0,
                                                      horizontal: 15),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                gapPadding: 0.5,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromRGBO(
                                                      255, 100, 100, 1),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                gapPadding: 0.5,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromRGBO(
                                                      255, 100, 100, 1),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                gapPadding: 0.5,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromARGB(
                                                      255, 221, 225, 232),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                // gapPadding: 100,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromARGB(
                                                      255, 221, 225, 232),
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Color(0xFFF7F8F9),
                                            ),
                                            validator: (value) {
                                              if (value!.trim().isEmpty) {
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
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 17,
                                                  fontFamily: 'Urbanist',
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.30,
                                                  letterSpacing: -0.28,
                                                ),
                                              ),
                                              CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                // Display a CupertinoDatePicker in date picker mode.
                                                onPressed: () => _showDialog(
                                                  CupertinoDatePicker(
                                                    // initialDateTime:
                                                    //     date.add(Duration(seconds: 1)),
                                                    initialDateTime: snapshot
                                                        .data!.start!.dateTime!
                                                        .toLocal(),
                                                    // minimumDate: DateTime.now(),
                                                    // maximumDate: DateTime.now()
                                                    //     .add(Duration(days: 3650)),
                                                    //  minimumDate: _minDate,
                                                    maximumDate:
                                                        DateTime.now().copyWith(
                                                      year:
                                                          DateTime.now().year +
                                                              10,
                                                      month: 12,
                                                      day: 31,
                                                    ),
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .date,
                                                    use24hFormat: false,
                                                    // This is called when the user changes the date.
                                                    onDateTimeChanged:
                                                        (DateTime newDate) {
                                                      print(snapshot.data!
                                                          .start!.dateTime!
                                                          .toLocal());
                                                      date = newDate;
                                                      //   setState(
                                                      //       () => date = newDate);
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
                                                        fontSize: 16.0,
                                                        fontFamily: 'Urbanist',
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .only(end: 0),
                                                      child: Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color: blackColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 0),
                                          child: _DatePickerItem(
                                            children: <Widget>[
                                              Text(
                                                'Start Time',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 17,
                                                  fontFamily: 'Urbanist',
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.30,
                                                  letterSpacing: -0.28,
                                                ),
                                              ),
                                              CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                // Display a CupertinoDatePicker in time picker mode.
                                                onPressed: () => _showDialog(
                                                  CupertinoDatePicker(
                                                    initialDateTime: startTime,
                                                    // startTime.isAfter(DateTime.now())
                                                    //     ? startTime
                                                    //     : DateTime.now(),
                                                    // minimumDate: date.day ==
                                                    //             DateTime.now()
                                                    //                 .day &&
                                                    //         date.month ==
                                                    //             DateTime.now()
                                                    //                 .month &&
                                                    //         date.year ==
                                                    //             DateTime.now()
                                                    //                 .year
                                                    //     ? _minTime
                                                    //     : null,
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .time,
                                                    use24hFormat: false,
                                                    // This is called when the user changes the time.
                                                    onDateTimeChanged:
                                                        (DateTime newTime) {
                                                      // setState(() =>
                                                      startTime = newTime;
                                                      // );
                                                      print(
                                                          "NEW TIME IS $newTime");
                                                      var jiffy = Jiffy.parse(
                                                          newTime.toString());
                                                      startFormat =
                                                          jiffy.format(
                                                              pattern:
                                                                  "hh:mm a");
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
                                                        fontSize: 16.0,
                                                        fontFamily: 'Urbanist',
                                                        color: timeColor,
                                                        // color: Color(0xFFD77D7C),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .only(start: 0),
                                                      child: Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color: blackColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 0),
                                          child: _DatePickerItem(
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Text(
                                                    'End Time',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 17,
                                                      fontFamily: 'Urbanist',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 1.30,
                                                      letterSpacing: -0.28,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                // Display a CupertinoDatePicker in time picker mode.
                                                onPressed: () => _showDialog(
                                                  CupertinoDatePicker(
                                                    initialDateTime: endTime,
                                                    // endTime.isAfter(DateTime.now())
                                                    //     ? endTime
                                                    //     : DateTime.now(),
                                                    minimumDate: date.day ==
                                                                DateTime.now()
                                                                    .day &&
                                                            date.month ==
                                                                DateTime.now()
                                                                    .month &&
                                                            date.year ==
                                                                DateTime.now()
                                                                    .year
                                                        ? _minTime
                                                        : null,
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .time,
                                                    use24hFormat: false,
                                                    // This is called when the user changes the time.
                                                    onDateTimeChanged:
                                                        (DateTime newTime) {
                                                      // setState(() =>
                                                      endTime = newTime;
                                                      // );
                                                      print(newTime.toString());
                                                      var jiffy = Jiffy.parse(
                                                          newTime.toString());
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
                                                        fontSize: 16.0,
                                                        fontFamily: 'Urbanist',
                                                        color: timeColor,
                                                        // color: Color(0xFFD77D7C),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .only(end: 0),
                                                      child: Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
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
                                          child: Text(errorMessage,
                                              style: textStyle),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (startTime.hour >
                                                      endTime.hour ||
                                                  (startTime.hour ==
                                                          endTime.hour &&
                                                      startTime.minute >
                                                          endTime.minute)) {
                                                setState(() {
                                                  print('start after end');

                                                  final FormState form =
                                                      _formKey.currentState!;
                                                  form.validate();
                                                  errorMessage =
                                                      "Start time cannot be after end time.";
                                                  valid = false;
                                                  timeRed = true;
                                                });
                                              } else if (startTime.hour ==
                                                      endTime.hour &&
                                                  startTime.minute ==
                                                      endTime.minute) {
                                                print('start = end');
                                                final FormState form =
                                                    _formKey.currentState!;
                                                form.validate();
                                                setState(() {
                                                  errorMessage =
                                                      "Start time cannot be equal to end time.";
                                                  valid = false;
                                                  timeRed = true;
                                                });
                                              } else if (date.day ==
                                                      today.day &&
                                                  date.month == today.month &&
                                                  date.year == today.year &&
                                                  (startTime.hour <
                                                          (today.hour) ||
                                                      (startTime.hour ==
                                                              today.hour &&
                                                          startTime.minute <
                                                              today.minute))) {
                                                setState(() {
                                                  final FormState form =
                                                      _formKey.currentState!;
                                                  form.validate();
                                                  errorMessage =
                                                      "Time cannot be in the past.";
                                                  valid = false;
                                                  timeRed = true;
                                                });
                                                // } else if (_apptNameController
                                                //         .text.isEmpty ||
                                                //     _drController.text.isEmpty ||
                                                //     _hospitalController.text.isEmpty) {
                                                //   setState(() {
                                                //     errorMessage =
                                                //         "Please fill all fields.";
                                                //     valid = false;
                                                //     timeRed = false;
                                                //   });

                                                //   print("not added because empty name");
                                              } else {
                                                setState(() {
                                                  timeRed = false;
                                                  errorMessage = "";
                                                  // _handleSignIn();
                                                  valid = true;
                                                });
                                                final FormState form =
                                                    _formKey.currentState!;
                                                print(form);
                                                if (valid == true &&
                                                    form.validate()) {
                                                  print("now signed in");
                                                  Event event =
                                                      Event(); // Create object of event
                                                  event.summary = appt == ''
                                                      ? appt
                                                      : newAppt; //Setting summary of object (name of event)
                                                  event.location = _hospitalKey
                                                      .toString()
                                                      .trim();
                                                  event.description =
                                                      _drKey.toString().trim();

                                                  EventDateTime start =
                                                      new EventDateTime();
                                                  // start.date = date; //setting start time
                                                  start.dateTime = startTime;
                                                  start.timeZone = DateTime
                                                          .now()
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
                                                      timeZone: DateTime.now()
                                                          .timeZoneName);
                                                  // event.start!.date = date;

                                                  EventDateTime end =
                                                      new EventDateTime();
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
                                                      timeZone: DateTime.now()
                                                          .timeZoneName);
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
                                                      BorderRadius.circular(
                                                          40)),
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
                            );
                          }
                        }
                        return CircularProgressIndicator(color: pinkColor);
                      }),
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
