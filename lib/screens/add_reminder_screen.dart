import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/login_screen.dart';
import 'package:preggo/reminder.dart';

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
  DateTime _minDate = DateTime.now();
  DateTime _minTime = DateTime.now();
  var timeFormat = Jiffy.now().format(pattern: "hh:mm a");
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

  _showDatePicker() {
    _showDialog(
      CupertinoDatePicker(
        initialDateTime: selectedDate.isAfter(DateTime.now())
            ? selectedDate
            : DateTime.now(),
        minimumDate: _minDate,
        maximumDate: DateTime.now().copyWith(
          year: DateTime.now().year + 10,
          month: 12,
          day: 31,
        ),

        /// Test for the date limitation(2024-2034), up to 10 years only.
        /// Note that we set the initial Date Time one more year to avoid any picker issue, just for testing.
        // initialDateTime:
        //     DateTime.now().copyWith(
        //   year: DateTime.now().year + 2,
        // ),
        // minimumDate: DateTime.now().copyWith(
        //   year: DateTime.now().year + 1,
        // ),
        // maximumDate: DateTime.now().copyWith(
        //   year: DateTime.now().year + 11,
        //   month: 12,
        //   day: 31,
        // ),

        /// End the test
        /// Test for the date limitation(2024-2034), up to 10 years only.
        /// Note that we set the initial Date Time one more year to avoid any picker issue, just for testing.
        // initialDateTime:
        //     DateTime.now().copyWith(
        //   year: DateTime.now().year + 2,
        // ),
        // minimumDate: DateTime.now().copyWith(
        //   year: DateTime.now().year + 1,
        // ),
        // maximumDate: DateTime.now().copyWith(
        //   year: DateTime.now().year + 11,
        //   month: 12,
        //   day: 31,
        // ),

        /// End the test
        mode: CupertinoDatePickerMode.date,
        // This is called when the user changes the date.
        onDateTimeChanged: (DateTime newDate) {
          setState(
            () {
              selectedDate = DateTime(
                newDate.year,
                newDate.month,
                newDate.day,
              );
              _minDate = DateTime.now();
            },
          );
        },
      ),
    );
  }

  _showTimePicker() {
    _showDialog(
      CupertinoDatePicker(
        initialDateTime: selectedTime.isAfter(DateTime.now())
            ? selectedTime
            : DateTime.now(),
        minimumDate: selectedDate.day == DateTime.now().day &&
                selectedDate.month == DateTime.now().month &&
                selectedDate.year == DateTime.now().year
            ? _minTime
            : null,
        mode: CupertinoDatePickerMode.time,
        onDateTimeChanged: (DateTime newTime) {
          setState(() {
            selectedTime = newTime;
            // _minTime = DateTime.now();
            _minTime = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              DateTime.now().hour,
              DateTime.now().minute,
            );
          });
          print(newTime.toString());
          var jiffy = Jiffy.parse(newTime.toString());
          timeFormat = jiffy.format(pattern: "hh:mm a");
          print(timeFormat);
        },
      ),
    );
  }

  Future<void> addNewReminder() async {
    try {
      DateTime dateTime = DateTime(
        selectedDate.month,
        selectedDate.day,
        selectedDate.year,
        12,
        4,
      );
      //NUHA'S CODE =================PAY ATTENSION!!!=================
      //  try {
      // addReminderToSystem(
      //  dateTime: dateTime,
      //    title: _reminderTitleController.text.trim(),
      //    body: _reminderDescriptionController.text.trim(),
      //  );
      //END OF NUHA'S CODE =================PAY ATTENSION!!!=================

      /// Get user uuid
      /// Create new reminders collection
      /// Insert all data
      final String? currentUserUuid = FirebaseAuth.instance.currentUser?.uid;
      // final String userUid = "5ALfd5zhZnOsB8mdc5hN9MbhLry1";
      if (currentUserUuid != null && _formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
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
                "${selectedDate.month}-${selectedDate.day}-${selectedDate.year}",
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
          if (selectedDays.isEmpty) {
            await scheduleRepeatingAlarms(
              title: _reminderTitleController.text.trim(),
              dayStr: selectedDate.weekday.toString(),
              hour: selectedTime.hour,
              repeat: false,
              minute: selectedTime.minute,
              date: selectedDate,
            );
          }
          selectedDays.forEach((e) async {
            await scheduleRepeatingAlarms(
              title: _reminderTitleController.text.trim(),
              dayStr: e['id'],
              hour: selectedTime.hour,
              minute: selectedTime.minute,
              date: selectedDate,
            );
          });

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
                    content: const Text("Saved successfully!"),
                  );
                });
          }
          setState(() {
            isLoading = false;
            _reminderTitleController = TextEditingController();
            _reminderDescriptionController.clear();

            selectedDate = DateTime.now();
            selectedTime = DateTime.now();
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }
  // GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  // final GlobalKey<FormFieldState> _reminderTitleKey =
  //     GlobalKey<FormFieldState>();
  late TextEditingController _reminderTitleController;

  late TextEditingController _reminderDescriptionController;

  @override
  void initState() {
    super.initState();
    _reminderTitleController = TextEditingController();
    _reminderDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _reminderTitleController.dispose();
    _reminderDescriptionController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12.0,
          fontFamily: 'Urbanist',
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.normal,
        );
    return Scaffold(
      backgroundColor: backGroundPink,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.bottomLeft,
              child: BackButton(
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const Text(
              "Add a new reminder",
              style: TextStyle(
                color: Color(0xFFD77D7C),
                fontSize: 32,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                // height: 1.30,
                letterSpacing: -0.28,
              ),
            ),
            const SizedBox(
              height: 10,
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
                                  //title label
                                  margin:
                                      const EdgeInsets.only(top: 30, left: 5),
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    "Reminder Title",
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
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: TextFormField(
                                    maxLength: 25,
                                    controller: _reminderTitleController,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'Urbanist',
                                      // color: pinkColor,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 15),
                                      focusedErrorBorder: OutlineInputBorder(
                                        gapPadding: 0.5,
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          width: 0.50,
                                          color:
                                              Color.fromRGBO(255, 100, 100, 1),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        gapPadding: 0.5,
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          width: 0.50,
                                          color:
                                              Color.fromRGBO(255, 100, 100, 1),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        gapPadding: 0.5,
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          width: 0.50,
                                          color: Color.fromARGB(
                                              255, 221, 225, 232),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        // gapPadding: 100,
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          width: 0.50,
                                          color: Color.fromARGB(
                                              255, 221, 225, 232),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF7F8F9),
                                    ),
                                    // autovalidateMode:
                                    //     AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field cannot be empty.";
                                      }
                                      return null;
                                      // if (!RegExp(r'^[a-z A-Z0-9]+$')
                                      //     .hasMatch(value)) {
                                      //   //allow alphanumerical only AND SPACE
                                      //   return "Please enter letters only.";
                                      // } else {
                                      //   return null;
                                      // }
                                    },
                                  ),
                                ), //end of text field

                                /// Description
                                Container(
                                  //title name label
                                  margin:
                                      const EdgeInsets.only(top: 5, left: 5),
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    "Reminder Description",
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: TextFormField(
                                    maxLines: 3,
                                    maxLength: 150,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'Urbanist',
                                      // color: pinkColor,
                                    ),
                                    controller: _reminderDescriptionController,
                                    decoration: InputDecoration(
                                      hintText: "Optional",
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Urbanist',
                                        // color: pinkColor,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 15),
                                      focusedErrorBorder: OutlineInputBorder(
                                        gapPadding: 0.5,
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          width: 0.50,
                                          color:
                                              Color.fromRGBO(255, 100, 100, 1),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        gapPadding: 0.5,
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          width: 0.50,
                                          color:
                                              Color.fromRGBO(255, 100, 100, 1),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        gapPadding: 0.5,
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          width: 0.50,
                                          color: Color.fromARGB(
                                              255, 221, 225, 232),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        // gapPadding: 100,
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          width: 0.50,
                                          color: Color.fromARGB(
                                              255, 221, 225, 232),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF7F8F9),
                                    ),
                                    // autovalidateMode:
                                    //     AutovalidateMode.onUserInteraction,
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return "This field cannot be empty.";
                                    //   }
                                    //   if (!RegExp(r'^[a-z A-Z0-9]+$')
                                    //       .hasMatch(value)) {
                                    //     //allow alphanumerical only AND SPACE
                                    //     return "Please enter letters only.";
                                    //   } else {
                                    //     return null;
                                    //   }
                                    // },
                                  ),
                                ), //end of text field

                                /// End description
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: CustomResizeWidget(
                                    children: <Widget>[
                                      const Text(
                                        "Date",
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 17,
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w700,
                                          height: 1.30,
                                          letterSpacing: -0.28,
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            // Display a CupertinoDatePicker in date picker mode.
                                            onPressed: _showDatePicker,
                                            child: Text(
                                              '${selectedDate.month}-${selectedDate.day}-${selectedDate.year}',
                                              style: const TextStyle(
                                                //date size
                                                fontSize: 16.0,
                                                fontFamily: 'Urbanist',

                                                /// Date Color
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _showDatePicker,
                                            child: const Padding(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      start: 5),
                                              child: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                CustomResizeWidget(
                                  children: <Widget>[
                                    const Text(
                                      "Time",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 17,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w700,
                                        height: 1.30,
                                        letterSpacing: -0.28,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          // Display a CupertinoDatePicker in time picker mode.
                                          onPressed: _showTimePicker,
                                          // In this example, the time value is formatted manually.
                                          // You can use the intl package to format the value based on
                                          // the user's locale settings.
                                          child: Text(
                                            timeFormat,
                                            style: const TextStyle(
                                              //time size
                                              fontSize: 16.0,
                                              fontFamily: 'Urbanist',

                                              /// Time Color
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: _showTimePicker,
                                          child: const Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                start: 5),
                                            child: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                /// Repeat Widget
                                CustomResizeWidget(
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
                                  children: [
                                    const Text(
                                      "Repeat",
                                      style: TextStyle(
                                        // color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Urbanist',
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 10),
                                        child: SingleChildScrollView(
                                          // padding: const EdgeInsets.symmetric(horizontal: 10),
                                          scrollDirection: Axis.horizontal,
                                          reverse: true,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: selectedDays.isEmpty
                                                ? [
                                                    const Text(
                                                      "Never",
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        fontFamily: 'Urbanist',

                                                        /// Never Color
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ]
                                                : List.generate(
                                                    selectedDays.length,
                                                    (index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    5.0),
                                                        child: Text(
                                                          selectedDays[index]
                                                              ['short'],
                                                          style:
                                                              const TextStyle(
                                                            //selected days size
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                'Urbanist',

                                                            /// Selected days Color
                                                            color: Colors.black,
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
                                      padding:
                                          EdgeInsetsDirectional.only(start: 5),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        // color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                // Container(
                                //   margin:
                                //       const EdgeInsets.symmetric(vertical: 15),
                                //   // decoration: const BoxDecoration(
                                //   //   border: Border(
                                //   //     top: BorderSide(
                                //   //       color: CupertinoColors.inactiveGray,
                                //   //       width: 0.0,
                                //   //     ),
                                //   //     bottom: BorderSide(
                                //   //       color: CupertinoColors.inactiveGray,
                                //   //       width: 0.0,
                                //   //     ),
                                //   //   ),
                                //   // ),
                                //   child: _DatePickerItem(
                                //     child: GestureDetector(
                                //       onTap: () async {
                                //         await showDialog(
                                //           context: context,
                                //           builder: (context) {
                                //             return DaysDialog(
                                //               days: days,
                                //               selectedDays: selectedDays,
                                //             );
                                //           },
                                //         ).then((value) {
                                //           setState(() {
                                //             selectedDays.sort((a, b) =>
                                //                 a['id'].compareTo(b['id']));
                                //           });
                                //         });
                                //       },
                                //       child: Container(
                                //         width:
                                //             MediaQuery.sizeOf(context).width * 0.94,
                                //         height: 55,
                                //         padding: const EdgeInsets.symmetric(
                                //             horizontal: 10),
                                //         child: Row(
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceBetween,
                                //           // mainAxisSize: MainAxisSize.min,
                                //           children: [
                                //             const Text(
                                //               "Repeat",
                                //               style: TextStyle(
                                //                 // color: Colors.black,
                                //                 fontSize: 20,
                                //                 fontWeight: FontWeight.bold,
                                //               ),
                                //             ),
                                //             Expanded(
                                //               flex: 3,
                                //               child: Padding(
                                //                 padding: const EdgeInsetsDirectional
                                //                     .only(start: 10),
                                //                 child: SingleChildScrollView(
                                //                   // padding: const EdgeInsets.symmetric(horizontal: 10),
                                //                   scrollDirection: Axis.horizontal,
                                //                   reverse: true,
                                //                   child: Row(
                                //                     mainAxisSize: MainAxisSize.min,
                                //                     children: selectedDays.isEmpty
                                //                         ? [
                                //                             const Text(
                                //                               "Never",
                                //                               style: TextStyle(
                                //                                 fontSize: 22.0,
                                //                                 color: Color(
                                //                                     0xFFD77D7C),
                                //                               ),
                                //                             ),
                                //                           ]
                                //                         : List.generate(
                                //                             selectedDays.length,
                                //                             (index) {
                                //                               return Padding(
                                //                                 padding:
                                //                                     const EdgeInsets
                                //                                         .symmetric(
                                //                                         horizontal:
                                //                                             5.0),
                                //                                 child: Text(
                                //                                   selectedDays[
                                //                                           index]
                                //                                       ['short'],
                                //                                   style:
                                //                                       const TextStyle(
                                //                                     fontSize: 22.0,
                                //                                     color: Color(
                                //                                         0xFFD77D7C),
                                //                                   ),
                                //                                 ),
                                //                               );
                                //                             },
                                //                           ),
                                //                   ),
                                //                 ),
                                //               ),
                                //             ),
                                //             const Padding(
                                //               padding: EdgeInsetsDirectional.only(
                                //                   start: 5),
                                //               child: Icon(
                                //                 Icons.keyboard_arrow_down,
                                //                 // color: Colors.black,
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),

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
                                const SizedBox(height: 30),
                                SizedBox(
                                  height: 45.0,
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
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : const Text("Add Reminder",
                                            style: TextStyle(
                                              fontFamily: 'Urbanist',
                                            )),
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
      ),
    );
  }
}

class CustomResizeWidget extends StatelessWidget {
  const CustomResizeWidget({
    super.key,
    required this.children,
    this.onTap,
  });

  final List<Widget> children;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
    return Center(
      child: AlertDialog(
        title: const Text(
          "Select",
          style: TextStyle(
            fontFamily: 'Urbanist',
          ),
        ),
        contentPadding: EdgeInsets.zero,
        // insetPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        actions: [
          TextButton(
            // style: ,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Urbanist',
                )),
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
            child: const Text(
              "Save",
              style: TextStyle(
                color: pinkColor,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ],
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.74,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.days.length,
              (i) {
                return Theme(
                  data: ThemeData(
                    unselectedWidgetColor:
                        widget.days[i]['selected'] ? pinkColor : Colors.black54,
                  ),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: pinkColor,
                    title: Text(
                      widget.days[i]['day'],
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
                              (element) =>
                                  element['id'] == widget.days[i]['id'],
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
      ),
    );
  }
}