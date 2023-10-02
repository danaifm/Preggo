import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_calendar/calendar.dart';

class viewAppointment extends StatefulWidget {
  //const SignUp({Key? key}) : super(key: key);
  late final String userId;
  @override
  State<StatefulWidget> createState() {
    return _viewAppointment();
  }
}

class _viewAppointment extends State<viewAppointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.month,
        initialDisplayDate: DateTime(2023, 09, 01),
      ),
    );
  }
}
