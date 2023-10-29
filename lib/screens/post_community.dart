import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension CapitalizeAfterDigit on String {
  String get capitalizeAnyWord {
    final RegExp digitRegex = RegExp(r"^\d");

    if (digitRegex.hasMatch(this) == false) {
      // The input does not start with a digit
      // Capitalize the first letter and the rest of the word in lower case
      return this[0].toUpperCase() + substring(1).toLowerCase();
    } else {
      // The input starts with a digit
      // Capitalize the first letter after the digit and the rest of the word in lower case
      return replaceAllMapped(RegExp(r'(\d+)([a-zA-Z])([a-zA-Z]*)'), (match) {
        final String firstLetter = match.group(2)?.toUpperCase() ?? '';
        final String restOfWord = match.group(3)?.toLowerCase() ?? '';
        return '${match.group(1)}$firstLetter$restOfWord';
      });
    }
  }
}

class PostCommunityScreen extends StatefulWidget {
  const PostCommunityScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return PostCommunityScreenState();
  }
}

class PostCommunityScreenState extends State<PostCommunityScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedTime = DateTime.now();
  DateTime _minDate = DateTime.now();

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

  Future<void> addNewPost() async {
    try {
      final userUid = FirebaseAuth.instance.currentUser?.uid;
      if (userUid != null && _formKey.currentState!.validate()) {
        final prefs = await SharedPreferences.getInstance();
        final username = prefs.getString("username")?.capitalizeAnyWord;
        final date = DateTime.now();
        final String formatedDate =
            DateFormat("yyyy/MM/dd hh:mm a").format(date);
        int comments = 0;

        // final DateTime myDate =
        //     DateFormat("yyyy/MM/dd hh:mm a").parse(formatedDate);

        // final Timestamp timestamp = Timestamp.fromDate(myDate);
        final post = {
          "title": _postTitleController.text,
          "body": _postDescriptionController.text,
          "timestamp": formatedDate,
          "userID": userUid,
          "username": username,
          "comments": comments,
        };
        final communityCollection =
            FirebaseFirestore.instance.collection("community");
        await communityCollection.add(post).then((value) {
          if (mounted) {
            // _successDialogPost();
            _successDialog();
          }
          setState(() {
            isLoading = false;
            _postTitleController.clear();
            _postDescriptionController.clear();
          });
        }).catchError((error) {});
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
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
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
                              // color: pinkColor,
                              // border: Border.all(
                              //   width: 1.3,
                              //   color: Colors.black,
                              // ),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Done
                          const Text(
                            "Post added successfully!",
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen()),
                                  );
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
            ),
          );
        });
  }

  Future<dynamic> _successDialogPost() {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.70,
              height: MediaQuery.sizeOf(context).height * 0.33,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
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
                          // color: pinkColor,
                          // border: Border.all(
                          //   width: 1.3,
                          //   color: Colors.black,
                          // ),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Done
                      const Text(
                        "Post added successfully!",
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen()),
                              );
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
          );
        });
  }

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _postTitleController;

  late TextEditingController _postDescriptionController;

  @override
  void initState() {
    super.initState();
    _postTitleController = TextEditingController();
    _postDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _postTitleController.dispose();
    _postDescriptionController.dispose();
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

  void backButton() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.40;
    final width = MediaQuery.sizeOf(context).width * 0.85;
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
              "Add a new post",
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
                                    "Post Title",
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
                                    controller: _postTitleController,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'Urbanist',
                                      // color: pinkColor,
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
                                        // borderSide: BorderSide(color: darkGrayColor),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF7F8F9),
                                    ),
                                    // autovalidateMode:
                                    //     AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
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
                                    "Post Description",
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
                                  // height: 500,
                                  //baby name text field
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: TextFormField(
                                    maxLines: 7,
                                    minLines: 7,
                                    maxLength: 250,

                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'Urbanist',
                                      // color: pinkColor,
                                    ),
                                    // maxLengthEnforcement:
                                    //     MaxLengthEnforcement.none,

                                    controller: _postDescriptionController,
                                    // scrollPadding: EdgeInsets.zero,

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
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text(errorMessage, style: textStyleError),
                                ),
                                // const SizedBox(height: 30),
                                SizedBox(
                                  height: 45.0,
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.73,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      addNewPost();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: blackColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      // padding: const EdgeInsets.only(
                                      //     left: 85,
                                      //     top: 15,
                                      //     right: 85,
                                      //     bottom: 15),
                                    ),
                                    child: const Text("Add Post",
                                        style: TextStyle(
                                          fontFamily: 'Urbanist',
                                        )),
                                  ),
                                ),

                                /// With MediaQuery width
                                // SizedBox(
                                //   height: 45.0,
                                //   width:
                                //       MediaQuery.sizeOf(context).width * 0.30,
                                //   child: ElevatedButton(
                                //     onPressed: addNewPost,
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: blackColor,
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(40),
                                //       ),
                                //       // padding: const EdgeInsets.only(
                                //       //     left: 85,
                                //       //     top: 15,
                                //       //     right: 85,
                                //       //     bottom: 15),
                                //     ),
                                //     child: const Text("Add Post",
                                //         style: TextStyle(
                                //           fontFamily: 'Urbanist',
                                //         )),
                                //   ),
                                // )
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
            fontSize: 17,
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
