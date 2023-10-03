import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:preggo/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:http/http.dart' as http;

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AddReminderScreenState();
  }
}

class AddReminderScreenState extends State<AddReminderScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedTime = DateTime.now();

  var startFormat = Jiffy.now().format(pattern: "hh:mm a");
  var endFormat = Jiffy.now().format(pattern: "hh:mm a");
  var errorMessage = "";

  List<Map<String, dynamic>> days = [
    {
      "id": "1",
      "day": "Every Sunday",
      "short": "Sun",
      "selected": false,
    },
    {
      "id": "2",
      "day": "Every Monday",
      "short": "Mon",
      "selected": false,
    },
    {
      "id": "3",
      "day": "Every Tuesday",
      "short": "Tue",
      "selected": false,
    },
    {
      "id": "4",
      "day": "Every Wednesday",
      "short": "Wed",
      "selected": false,
    },
    {
      "id": "5",
      "day": "Every Thursday",
      "short": "Thu",
      "selected": false,
    },
    {
      "id": "6",
      "day": "Every Friday",
      "short": "Fri",
      "selected": false,
    },
    {
      "id": "7",
      "day": "Every Saturday",
      "short": "Sat",
      "selected": false,
    },
  ];

  List<Map<String, dynamic>> selectedDays = [];

  bool isLoading = false;

  Future<void> addNewReminder() async {
    try {
      setState(() {
        isLoading = true;
      });

      /// Get user uuid
      /// Create new reminders collection
      /// Insert all data
      final String? currentUserUuid = FirebaseAuth.instance.currentUser?.uid;
      // final String userUid = "5ALfd5zhZnOsB8mdc5hN9MbhLry1";
      if (currentUserUuid != null) {
        final remindersCollection = FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserUuid)
            .collection("reminders");

        // final docId = await remindersCollection.get();
        await remindersCollection.add(
          {
            "id": "",
            "title": _reminderTitleController.text.trim(),
            "description": _reminderDescriptionController.text.trim(),
            "date":
                "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
            "time": TimeOfDay.fromDateTime(selectedTime).format(context),
            "repeat": selectedDays,
          },
        ).then((value) async {
          await remindersCollection.doc(value.id).set(
            {
              "id": value.id,
            },
            SetOptions(merge: true),
          );
          if (mounted) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Okay"),
                      ),
                    ],
                    content: const Text("Done"),
                  );
                });
          }
          setState(() {
            isLoading = false;
            _reminderTitleController.clear();
            _reminderDescriptionController.clear();
            selectedDate = DateTime.now();
            selectedTime = DateTime.now();
          });
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

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

  void prompt(String url) async {
    // if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
    // } else {
    throw 'Could not launch $url';
    // }
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final GlobalKey<FormFieldState> _reminderTitleKey =
  //     GlobalKey<FormFieldState>();
  final TextEditingController _reminderTitleController =
      TextEditingController();

  final TextEditingController _reminderDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(
            height: 85,
          ),
          const Text(
            "Add a new reminder",
            style: TextStyle(
              color: Color(0xFFD77D7C),
              fontSize: 32,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
              height: 1.30,
              letterSpacing: -0.28,
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 0.0,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(80.0),
                ),
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
                                margin: const EdgeInsets.only(top: 30, left: 5),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Reminder title",
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
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: TextFormField(
                                  maxLength: 25,
                                  controller: _reminderTitleController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 15),
                                    focusedErrorBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        width: 0.50,
                                        color: Color.fromRGBO(255, 100, 100, 1),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        width: 0.50,
                                        color: Color.fromRGBO(255, 100, 100, 1),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        width: 0.50,
                                        color:
                                            Color.fromARGB(255, 221, 225, 232),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // gapPadding: 100,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        width: 0.50,
                                        color:
                                            Color.fromARGB(255, 221, 225, 232),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF7F8F9),
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
                              ), //end of appointment name text field

                              /// Description
                              Container(
                                //Appointment name label
                                margin: const EdgeInsets.only(top: 10, left: 5),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Reminder description",
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
                                  maxLines: 3,
                                  maxLength: 150,
                                  controller: _reminderDescriptionController,
                                  decoration: InputDecoration(
                                    hintText: "Optional",
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 15),
                                    focusedErrorBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        width: 0.50,
                                        color: Color.fromRGBO(255, 100, 100, 1),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        width: 0.50,
                                        color: Color.fromRGBO(255, 100, 100, 1),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        width: 0.50,
                                        color:
                                            Color.fromARGB(255, 221, 225, 232),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // gapPadding: 100,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        width: 0.50,
                                        color:
                                            Color.fromARGB(255, 221, 225, 232),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF7F8F9),
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
                              ), //end of appointment name text field

                              /// End description
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: _DatePickerItem(
                                  children: <Widget>[
                                    const Text(
                                      "Date",
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
                                          initialDateTime: DateTime.now(),
                                          minimumDate: selectedDate,
                                          mode: CupertinoDatePickerMode.date,
                                          // This is called when the user changes the date.
                                          onDateTimeChanged:
                                              (DateTime newDate) {
                                            setState(
                                              () => selectedDate = DateTime(
                                                newDate.year,
                                                newDate.month,
                                                newDate.day,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // In this example, the date is formatted manually. You can
                                      // use the intl package to format the value based on the
                                      // user's locale settings.
                                      child: Text(
                                        '${selectedDate.month}-${selectedDate.day}-${selectedDate.year}',
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
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: _DatePickerItem(
                                  children: <Widget>[
                                    const Text(
                                      'Time',
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
                                          initialDateTime: selectedTime,
                                          mode: CupertinoDatePickerMode.time,

                                          // This is called when the user changes the time.
                                          onDateTimeChanged:
                                              (DateTime newTime) {
                                            setState(
                                                () => selectedTime = newTime);
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

                              /// Repeat Widget
                              Material(
                                // color: Colors.grey.shade200,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: InkWell(
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DaysDialog(
                                          days: days,
                                          selectedDays: selectedDays,
                                        );
                                      },
                                    ).then((value) {
                                      setState(() {
                                        selectedDays.sort((a, b) =>
                                            a['id'].compareTo(b['id']));
                                      });
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.94,
                                    height: 55,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Repeat",
                                          style: TextStyle(
                                            // color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(start: 10),
                                            child: SingleChildScrollView(
                                              // padding: const EdgeInsets.symmetric(horizontal: 10),
                                              scrollDirection: Axis.horizontal,
                                              reverse: true,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: List.generate(
                                                  selectedDays.length,
                                                  (index) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5.0),
                                                      child: Text(
                                                        selectedDays[index]
                                                            ['short'],
                                                        style: const TextStyle(
                                                          // color: Colors.black,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              start: 5),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            // color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Container(
                              //   decoration: const BoxDecoration(
                              //     color: blackColor,
                              //     border: Border(
                              //       bottom: BorderSide(
                              //         color: blackColor,
                              //         width: 1.0,
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(errorMessage, style: textStyle),
                              ),
                              Padding(
                                //start journey button
                                padding: const EdgeInsets.only(top: 40.0),
                                child: ElevatedButton(
                                  onPressed: addNewReminder,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: blackColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    padding: const EdgeInsets.only(
                                        left: 85,
                                        top: 15,
                                        right: 85,
                                        bottom: 15),
                                  ),
                                  child: isLoading
                                      ? const Center(
                                          child: SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : const Text(
                                          "Add reminder",
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

class DaysDialog extends StatefulWidget {
  const DaysDialog({
    super.key,
    required this.days,
    required this.selectedDays,
  });
  final List<Map<String, dynamic>> days;
  final List<Map<String, dynamic>> selectedDays;

  @override
  State<DaysDialog> createState() => _DaysDialogState();
}

class _DaysDialogState extends State<DaysDialog> {
  List<Map<String, dynamic>> tempDays = [];

  @override
  void initState() {
    super.initState();
    tempDays.addAll(widget.selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.90,
      child: AlertDialog(
        title: const Text("Select"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (tempDays.isNotEmpty) {
                  widget.selectedDays.clear();
                  widget.selectedDays.addAll(tempDays);
                } else {
                  widget.selectedDays.clear();
                }
              });
            },
            child: const Text("Done"),
          ),
        ],
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            widget.days.length,
            (i) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: CheckboxListTile(
                  activeColor: pinkColor,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    widget.days[i]['day'],
                    textAlign: TextAlign.end,
                  ),
                  value: widget.days[i]['selected'],
                  onChanged: (value) {
                    setState(
                      () {
                        widget.days[i]['selected'] = value;

                        if (value == true) {
                          tempDays.add({
                            'id': widget.days[i]['id'],
                            'short': widget.days[i]['short'],
                          });
                        } else {
                          tempDays.removeWhere(
                            (element) => element['id'] == widget.days[i]['id'],
                          );
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
