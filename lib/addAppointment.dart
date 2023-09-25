// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'colors.dart';
import 'package:jiffy/jiffy.dart';

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

  // var AMorPM;
  // if(DateTime.now().hour > 11)
  // var startTimeString = "" +
  //     DateTime.now().hour.toString() +
  //     ":" +
  //     DateTime.now().minute.toString();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                color: Colors.white,
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
                                //baby name label
                                margin: EdgeInsets.symmetric(vertical: 30),
                                // alignment: Alignment.centerLeft,
                                // child: Text(
                                //   "Baby's name",
                                //   textAlign: TextAlign.left,
                                //   style: TextStyle(
                                //     color: Color.fromARGB(255, 0, 0, 0),
                                //     fontSize: 20,
                                //     fontFamily: 'Urbanist',
                                //     fontWeight: FontWeight.w700,
                                //     height: 1.30,
                                //     letterSpacing: -0.28,
                                //   ),
                                // ),
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
                                        '$startFormat',
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
                                        '$endFormat',
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                          color: Color(0xFFD77D7C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
