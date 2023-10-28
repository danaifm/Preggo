import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:preggo/colors.dart';

Future<void> deleteReminderSuccess(
  BuildContext context,
) async {
  //deleting happens here

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
                        "Reminder deleted successfully!",
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  borderRadius: BorderRadius.circular(40)),
                              padding: const EdgeInsets.only(
                                  left: 70, top: 15, right: 70, bottom: 15),
                            ),
                            child: const Text(
                              "OK",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}

Future<void> deleteReminderById({
  required String reminderId,
  required BuildContext context,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        content: SizedBox(
          height: 130,
          child: Column(
            children: <Widget>[
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 30),
                  child: Text(
                    'Are you sure you want to delete this reminder?',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          "Cancel",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    height: 45.0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final usersCollection =
                                FirebaseFirestore.instance.collection("users");
                            final String? currentUserId =
                                FirebaseAuth.instance.currentUser?.uid;
                            final reminderCollection = usersCollection
                                .doc(currentUserId)
                                .collection("reminders");

                            /// Delete now
                            await reminderCollection
                                .doc(reminderId)
                                .delete()
                                .then((value) async {
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                await deleteReminderSuccess(context);
                              }
                            });
                          } catch (error) {
                            print("Delete reminder:: $error ##");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          padding: const EdgeInsets.only(
                              left: 30, top: 15, right: 30, bottom: 15),
                        ),
                        child: const Text(
                          "Delete",
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

class EditReminderScreen extends StatefulWidget {
  const EditReminderScreen({
    super.key,
    required this.reminderId,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.repeated,
  });
  final String reminderId;
  final String title;
  final String description;
  final String date;
  final String time;
  final List<Map<String, dynamic>> repeated;

  @override
  State<StatefulWidget> createState() {
    return EditReminderScreenState();
  }
}

class EditReminderScreenState extends State<EditReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _reminderTitleController;
  late TextEditingController _reminderDescriptionController;

  late DateTime selectedDate;
  late DateTime selectedTime;
  late String timeFormat;
  DateTime _minDate = DateTime.now();
  bool isLoading = false;

  var errorMessage = "";
  List<Map<String, dynamic>> selectedDays = [];

  List<Map<String, dynamic>> fixedDays = [
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

  _showDatePicker() {
    _showDialog(
      CupertinoDatePicker(
        initialDateTime:
            selectedDate.isAfter(DateTime.now()) ? selectedDate : null,
        minimumDate: DateTime.now(),
        maximumDate: DateTime.now().copyWith(
          year: DateTime.now().year + 10,
          month: 12,
          day: 31,
        ),
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (DateTime newDate) {
          setState(
            () {
              selectedDate = DateTime(
                newDate.year,
                newDate.month,
                newDate.day,
                selectedTime.hour,
                selectedTime.minute,
                selectedTime.second,
              );
              print("::: Selected date is: $selectedDate #");
              _minDate = DateTime.now();
            },
          );
        },
      ),
    );
  }

  _showTimePicker() {
    print("Selected Time:**# $selectedTime #");
    print("Selected DATE:# $selectedDate #");
    final initial = DateTime.now().isBefore(selectedDate);
    print("Selected initial:# $initial #");
    final isDateToday = selectedDate.year == DateTime.now().year &&
        selectedDate.month == DateTime.now().month &&
        selectedDate.day == DateTime.now().day;

    _showDialog(
      CupertinoDatePicker(
        initialDateTime: DateTime.now().isBefore(selectedDate) ||
                DateTime.now().isBefore(selectedTime)
            ? selectedTime
            : DateTime.now(),
        minimumDate: isDateToday
            ? DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                DateTime.now().hour,
                DateTime.now().minute,
              )
            : null,
        mode: CupertinoDatePickerMode.time,
        onDateTimeChanged: (DateTime newTime) {
          setState(() {
            selectedTime = DateTime(
              newTime.year,
              newTime.month,
              newTime.day,
              newTime.hour,
              newTime.minute,
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

  Future<void> editReminder() async {
    try {
      // final today = DateTime(DateTime.now().year, DateTime.now().month,
      //     DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
      // final isDateAfterToday = selectedDate.isAfter(today);
      // final isDateToday = selectedDate.year == DateTime.now().year &&
      //     selectedDate.month == DateTime.now().month &&
      //     selectedDate.day == DateTime.now().day;
      // final isSelectedTimeEqualOrGraterThanNow =
      //     selectedTime.hour == DateTime.now().hour &&
      //             selectedTime.minute == DateTime.now().minute ||
      //         selectedTime.hour > DateTime.now().hour &&
      //             selectedTime.minute > DateTime.now().minute;
      // final isSelectedTimeAfterNow = selectedTime.hour >= DateTime.now().hour &&
      //     selectedTime.minute > DateTime.now().minute;
      // final isSelectedTimeValid = isDateAfterToday ||
      //     isSelectedTimeEqualOrGraterThanNow ||
      //     isDateToday && isSelectedTimeAfterNow;

      final today = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
      final isDateAfterToday = selectedDate.isAfter(today);
      final isSelectedTimeEqualOrGraterThanNow =
          selectedTime.hour == DateTime.now().hour &&
                  selectedTime.minute == DateTime.now().minute ||
              selectedTime.hour > DateTime.now().hour &&
                  selectedTime.minute > DateTime.now().minute;
      final isSelectedTimeValid = isDateAfterToday ||
          isSelectedTimeEqualOrGraterThanNow ||
          selectedTime.isAfter(DateTime.now());
      print("EDIT REMINDER - SLEECTED DAYS:: $selectedDays ##");
      print("today:: $today #");
      print("isDateAfterToday:: $isDateAfterToday #");
      print("isSelectedTimeValid:: $isSelectedTimeValid #");
      // print("isSelectedTimeAfterNow:: $isSelectedTimeAfterNow #");
      print("selectedDate:: $selectedDate #");
      print("selectedTime:: $selectedTime #");

      final String? currentUserUuid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserUuid != null &&
          _formKey.currentState!.validate() &&
          isSelectedTimeValid == true) {
        setState(() {
          isLoading = true;
          errorMessage = "";
        });
        final remindersCollection = FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserUuid)
            .collection("reminders");

        await remindersCollection.doc(widget.reminderId).set(
          {
            "id": widget.reminderId,
            "title": _reminderTitleController.text.trim(),
            "description": _reminderDescriptionController.text.trim(),
            "date":
                "${selectedDate.month}-${selectedDate.day}-${selectedDate.year}",
            "time": TimeOfDay.fromDateTime(selectedTime).format(context),
            "repeat": selectedDays,
          },
          SetOptions(merge: true),
        ).then((value) async {
          if (mounted) {
            _successDialog();
          }
          setState(() {
            isLoading = false;
            _reminderTitleController = TextEditingController();
            _reminderDescriptionController.clear();

            selectedDate = DateTime.now();
            selectedTime = DateTime.now();
          });
        });
      } else if (isSelectedTimeValid == false) {
        setState(() {
          errorMessage = "Time cannot be in the past.";
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "";
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = "";
      });
    }
  }

  Future<dynamic> _successDialog() {
    return showDialog(
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
                    color: Colors.white,
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
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          "Reminder edited successfully!",
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                    borderRadius: BorderRadius.circular(40)),
                                padding: const EdgeInsets.only(
                                    left: 70, top: 15, right: 70, bottom: 15),
                              ),
                              child: const Text("OK",
                                  style: TextStyle(
                                    fontFamily: 'Urbanist',
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  Future<void> backButton() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          content: SizedBox(
            height: 130,
            child: Column(
              children: <Widget>[
                const Center(
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
                      padding: const EdgeInsets.symmetric(horizontal: 5),
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
                      padding: const EdgeInsets.symmetric(horizontal: 5),
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
    ).then((value) {
      // setState(() {});
    });
  }

  _updateDaysSelectedValue() {
    widget.repeated.map((element) {
      fixedDays.map((day) {
        print("Day:: ${day['id']} ##");
        print("Element:: ${element['id']} ##");
        if (day['id'] == element['id']) {
          day['selected'] = true;
        }
      }).toList();
    }).toList();

    setState(() {
      selectedDays = widget.repeated;
    });
  }

  initialData() async {
    try {
      _reminderTitleController = TextEditingController(text: widget.title);
      _reminderDescriptionController =
          TextEditingController(text: widget.description);
      selectedDate = DateFormat("MM-dd-yyyy").parse(widget.date);
      timeFormat = widget.time;
      final DateTime time = DateFormat("hh:mm a").parse(widget.time);
      selectedTime =
          DateTime.now().copyWith(hour: time.hour, minute: time.minute);

      print("Selected Time:####::: $selectedTime #after");
      setState(() {});
    } catch (error) {
      print("# Error ####::: ${error.toString()} #");
    }
  }

  @override
  void initState() {
    super.initState();
    initialData();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {},
    );
    // Update the days selected value by day id
    _updateDaysSelectedValue();
  }

  @override
  void dispose() {
    _reminderTitleController.dispose();
    _reminderDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12.0,
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.normal,
        );

    var textStyleError = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12.0,
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.normal,
        );
    return Scaffold(
      backgroundColor: backGroundPink,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: BackButton(
                onPressed: backButton,
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const Text(
              "Edit reminder",
              style: TextStyle(
                color: Color(0xFFD77D7C),
                fontSize: 32,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: TextFormField(
                                    maxLength: 25,
                                    controller: _reminderTitleController,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'Urbanist',
                                    ),
                                    decoration: InputDecoration(
                                      errorStyle: textStyleError,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 15),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide: BorderSide(
                                            color: textFieldBorderColor),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                        borderSide:
                                            BorderSide(color: darkGrayColor),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF7F8F9),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "This field cannot be empty.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: TextFormField(
                                    maxLines: 3,
                                    maxLength: 150,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'Urbanist',
                                    ),
                                    controller: _reminderDescriptionController,
                                    decoration: InputDecoration(
                                      hintText: "Optional",
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Urbanist',
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
                                  ),
                                ),
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
                                            onPressed: _showDatePicker,
                                            child: Text(
                                              '${selectedDate.month}-${selectedDate.day}-${selectedDate.year}',
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'Urbanist',
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
                                          onPressed: _showTimePicker,
                                          child: Text(
                                            timeFormat,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'Urbanist',
                                              color: errorMessage.isEmpty
                                                  ? Colors.black
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .error,
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
                                CustomResizeWidget(
                                  onTap: () async {
                                    log("Fixed Days:: $fixedDays ##");
                                    log("Selected Days:: $selectedDays ##");
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DaysDialog(
                                          days: fixedDays,
                                          selectedDays: selectedDays,
                                          onSave: (selectedDays) {
                                            setState(() {
                                              this.selectedDays = selectedDays;
                                            });
                                          },
                                        );
                                      },
                                    ).then((value) {
                                      setState(() {
                                        log("selectedDays:: $selectedDays ##");
                                        if (selectedDays.isNotEmpty) {
                                          selectedDays.sort((a, b) =>
                                              a['id'].compareTo(b['id']));
                                        } else {
                                          selectedDays.addAll(fixedDays
                                              .where((element) =>
                                                  element['selected'] == true)
                                              .toList());
                                        }
                                      });
                                    });
                                  },
                                  children: [
                                    const Text(
                                      "Repeat",
                                      style: TextStyle(
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
                                                            fontSize: 16.0,
                                                            fontFamily:
                                                                'Urbanist',
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
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text(errorMessage, style: textStyleError),
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  height: 45.0,
                                  child: ElevatedButton(
                                    onPressed: editReminder,
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
                                    child: const Text("Edit Reminder",
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
  DaysDialog({
    super.key,
    required this.days,
    required this.selectedDays,
    required this.onSave,
  });
  List<Map<String, dynamic>> days;
  List<Map<String, dynamic>> selectedDays;
  final void Function(List<Map<String, dynamic>> selectedDays) onSave;

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
            fontSize: 17,
          ),
        ),
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        actions: [
          TextButton(
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
                widget.onSave(tempDays);
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
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Urbanist',
                      ),
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
