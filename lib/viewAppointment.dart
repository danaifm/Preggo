import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleAPI;
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;
import 'package:http/http.dart' show BaseRequest, Response;

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
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: <String>[GoogleAPI.CalendarApi.calendarScope],
  );

  GoogleSignInAccount? _currentUser;

  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        //getGoogleEventsData();
      }
    });
    _googleSignIn.signInSilently();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.month,
        initialDisplayDate: DateTime(2023, 09, 01),
      ),
    );
  }
}
