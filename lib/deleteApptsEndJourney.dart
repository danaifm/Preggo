// ignore_for_file: library_private_types_in_public_api, camel_case_types, avoid_print

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:google_sign_in/google_sign_in.dart';

class deleteAppt extends StatefulWidget {
  const deleteAppt({super.key});
  @override
  _deleteAppt createState() => _deleteAppt();
}

deleteAllAppts() async {
  String? id = '';
  await _googleSignIn.signInSilently();
  final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
  final CalendarApi googleCalendarApi = CalendarApi(client!);

  var list = await googleCalendarApi.calendarList.list();
  var items = list.items;
  for (CalendarListEntry entry in items!) {
    if (entry.summary == "Preggo Calendar") {
      id = entry.id;
      break;
    }
  }
  if (id != '') {
    print('CALENDAR ID IS $id');
    googleCalendarApi.calendars
        .delete(
            id!) //this deletes entire calendar and there is a clear calendar method but it gives me an api exception
        .then((value) => print('deleted all from google calendar'));
  } else {
    print('no preggo calendar in google calendar to delete from');
  }
}

const _scopes = [CalendarApi.calendarScope];

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: _scopes,
);

class _deleteAppt extends State<deleteAppt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          color: darkBlackColor,
          minWidth: double.infinity,
          height: 48,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          onPressed: deleteAllAppts,
          child: const Text(
            'Clear google calendar',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
