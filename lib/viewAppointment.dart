import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleAPI;
// ignore: depend_on_referenced_packages
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;
// ignore: depend_on_referenced_packages
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

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    //clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: <String>[GoogleAPI.CalendarApi.calendarScope],
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    // dispose();
    _googleSignIn.disconnect();
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

  getAppointments() async {
    final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
    assert(client != null, 'authenticated client missing!');
    print(client);
    final GoogleAPI.CalendarApi googleCalendarApi =
        GoogleAPI.CalendarApi(client!);

    try {
      String? id;
      bool exists = false;
      var list = await googleCalendarApi.calendarList.list();
      var items = list.items;
      for (GoogleAPI.CalendarListEntry entry in items!) {
        print(entry.summary);
        if (entry.summary == "Preggo Calendar") {
          id = entry.id;
          exists = true;
          break;
        }
      }

      if (exists == false) {
        GoogleAPI.Calendar preggoCalendar =
            new GoogleAPI.Calendar(summary: "Preggo Calendar");
        googleCalendarApi.calendars.insert(preggoCalendar);
        for (GoogleAPI.CalendarListEntry entry in items) {
          if (entry.summary == "Preggo Calendar") {
            id = entry.id;
            break;
          }
        }
      }
      final GoogleAPI.Events calEvents =
          await googleCalendarApi.events.list(id!);
      final List<GoogleAPI.Event> appointments = <GoogleAPI.Event>[];
      if (calEvents.items != null) {
        for (int i = 0; i < calEvents.items!.length; i++) {
          final GoogleAPI.Event event = calEvents.items![i];
          if (event.start == null) {
            continue;
          }
          appointments.add(event);
        }
      }

      return appointments;
    } catch (e) {
      print('error in new method');
    }
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
      appBar: AppBar(
        title: const Text('Event Calendar'),
      ),
      body: FutureBuilder(
        future: getAppointments(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Stack(
            children: [
              SfCalendar(
                view: CalendarView.month,
                initialDisplayDate: DateTime(
                  2023,
                  8,
                  1,
                ),
                dataSource: GoogleDataSource(events: snapshot.data),
                monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              ),
              snapshot.data != null
                  ? Container()
                  : const Center(
                      child: CircularProgressIndicator(),
                    )
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_googleSignIn.currentUser != null) {
      _googleSignIn.disconnect();
      _googleSignIn.signOut();
    }

    super.dispose();
  }
}

class GoogleDataSource extends CalendarDataSource {
  GoogleDataSource({required List<GoogleAPI.Event>? events}) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.start?.date ?? event.start!.dateTime!.toLocal();
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].start.date != null;
  }

  @override
  DateTime getEndTime(int index) {
    final GoogleAPI.Event event = appointments![index];
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
    final GoogleAPI.Event event = appointments![index];
    return event.summary == null || event.summary!.isEmpty
        ? 'No Title'
        : event.summary!;
  }
}

class GoogleAPIClient extends IOClient {
  final Map<String, String> _headers;

  GoogleAPIClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url,
          headers: (headers != null ? (headers..addAll(_headers)) : headers));
}
