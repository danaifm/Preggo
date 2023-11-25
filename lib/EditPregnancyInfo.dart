// ignore_for_file: file_names, use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_init_to_null, unused_import, avoid_print, unused_element, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:preggo/NavBar.dart';
import 'package:preggo/SplashScreen.dart';
import 'package:preggo/baby_information.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/main.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:preggo/start_Journey.dart';
import 'package:intl/intl.dart';

class editPregnancyInfo extends StatefulWidget {
  //const SignUp({Key? key}) : super(key: key);
  late final String userId;
  @override
  State<StatefulWidget> createState() {
    return _editPregnancyInfo();
  }
}

class _editPregnancyInfo extends State<editPregnancyInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _nameKey = GlobalKey<FormFieldState>();
  final TextEditingController _babynameController = TextEditingController();

  String? gender;
  var selectedWeek = null;
  bool showError = false;
  String? selectedName;
  String? selectedGender;
  String babyDueDate = '';
  late Timestamp duedateTimestamp;
  String pregnancyID = '';
  String pregID = '';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    pregID = ModalRoute.of(context)?.settings.arguments as String;
    getPregnancyInfo().then((_) {
      setState(() {
        _babynameController.text = selectedName!;
        gender = selectedGender;
      });
    });
  }

  //GET PREGNANCY INFO FOR CURRENT PREGNANCY
  Future<void> getPregnancyInfo() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userUid = getUserId();
    print(userUid);

    final pregnancyInfoQuerySnapshot = await firestore
        .collection('users')
        .doc(userUid)
        .collection('pregnancyInfo')
        .doc(pregID)
        .get();

    if (pregnancyInfoQuerySnapshot.exists) {
      Map<String, dynamic> data =
          pregnancyInfoQuerySnapshot.data() as Map<String, dynamic>;
      // Save the values in global variables for later use
      selectedName = data['Baby\'s name'];
      selectedGender = data['Gender'];
      duedateTimestamp = data['DueDate'];
      babyDueDate = duedateTimestamp.toDate().toString();
      DateTime dateTime = DateTime.parse(babyDueDate);
      String formattedDateTime =
          DateFormat("yyyy/MM/dd, hh:mm a").format(dateTime);
      babyDueDate = formattedDateTime;

      print(
          "-----------$selectedName, $selectedGender, $babyDueDate-----------------");
    } else {
      print("nothing here");
    }
  }

  //RETRIEVE USERS ID
  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  //UPDATES PREGNANCY INFO TO FIRESTORE
  Future<void> updateBabyInfo(
      String pregnancy, String name, String gender) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userUid = getUserId();
    String collectionPath = 'users/$userUid/pregnancyInfo';

    // Create a map to hold the updated field values
    Map<String, dynamic> updatedData = {
      'Baby\'s name': name.trim(),
      'Gender': gender,
    };

    try {
      await firestore
          .collection(collectionPath)
          .doc(pregnancy)
          .set(updatedData, SetOptions(merge: true));
      print('Pregnancy info updated successfully!');
      _successDialog();
    } catch (e) {
      print('Failed to update pregnancy info: $e');
    }
  }

  //SHOWS CONFIRMATION MESSAGE WHEN LEAVING PAGE
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
                            //Navigator.pop(context, pregID);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BabyInformation(),
                                settings: RouteSettings(arguments: pregID),
                              ),
                            );
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

  //SUCCESS DIALOG AFTER SUCCESSFUL EDITING
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

                        // Done
                        const Text(
                          "Information Edited successfully!",
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backButton();

        return false;
      },
      child: Scaffold(
        backgroundColor: backGroundPink,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            SizedBox(
              height: 55,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    backButton();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Edit Baby Information",
                  style: TextStyle(
                    color: Color(0xFFD77D7C),
                    fontSize: 28,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
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
                            child: Column(children: [
                              Container(
                                //baby name label
                                margin: EdgeInsets.only(top: 30, left: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Baby's name",
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
                                  key: _nameKey,
                                  maxLength: 25,
                                  controller: _babynameController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 15),
                                    focusedErrorBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 0.50,
                                        color: Color.fromRGBO(255, 100, 100, 1),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 0.50,
                                        color: Color.fromRGBO(255, 100, 100, 1),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 0.50,
                                        color:
                                            Color.fromARGB(255, 221, 225, 232),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // gapPadding: 100,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 0.50,
                                        color:
                                            Color.fromARGB(255, 221, 225, 232),
                                      ),
                                    ),
                                    hintText: "Optional",
                                    filled: true,
                                    fillColor: Color(0xFFF7F8F9),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return null;
                                    } //allow empty field

                                    if (!RegExp(r'^[a-z A-Z]+$')
                                        .hasMatch(value)) {
                                      //allow upper and lower case alphabets and space if input is written
                                      return "Please Enter letters only";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ), //end of baby name text field

                              Container(
                                //babys gender label
                                margin: EdgeInsets.only(
                                    top: 30, left: 5, bottom: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Baby's gender",
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

                              Column(
                                //gender radio buttons
                                children: [
                                  RadioListTile(
                                      //key: _radioKey,
                                      visualDensity:
                                          const VisualDensity(vertical: -4.0),
                                      contentPadding: EdgeInsets.zero,
                                      activeColor: Color(0xFFD77D7C),
                                      title: Row(
                                        children: [
                                          Text('Girl'),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.female,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                      value: 'Girl',
                                      groupValue: gender,
                                      onChanged: (val) {
                                        setState(() {
                                          gender = val;
                                        });
                                      } //set state

                                      ),
                                  RadioListTile(
                                      visualDensity:
                                          const VisualDensity(vertical: -4.0),
                                      contentPadding: EdgeInsets.zero,
                                      activeColor: Color(0xFFD77D7C),
                                      title: Row(
                                        children: [
                                          Text('Boy'),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.male,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                      value: 'Boy',
                                      groupValue: gender,
                                      onChanged: (val) {
                                        setState(() {
                                          gender = val;
                                        });
                                      } //set state
                                      ),
                                  RadioListTile(
                                      visualDensity:
                                          const VisualDensity(vertical: -4.0),
                                      contentPadding: EdgeInsets.zero,
                                      activeColor: Color(0xFFD77D7C),
                                      title: Row(
                                        children: [
                                          Text('Unknown'),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.question_mark,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                      value: 'Unknown',
                                      groupValue: gender,
                                      onChanged: (val) {
                                        setState(() {
                                          gender = val;
                                        });
                                      } //set state
                                      ),
                                ], //radio buttons
                              ), //for radio buttons

                              Visibility(
                                visible: showError,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 12.5),
                                      child: Text(
                                        'Please select an option',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 203, 51, 40),
                                            fontSize: 13),
                                        textAlign: TextAlign.left,
                                      )),
                                ),
                              ),

                              /*Container(
                                //expected due date 
                                margin: EdgeInsets.only(
                                    top: 30, left: 5, bottom: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Expected Due Date",
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
                              SizedBox(height: 8,),

                              Row(
                                children: [
                                  SizedBox(width: 3,),
                                  Icon(
                                    Icons.event_outlined,
                                    color: pinkColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  
                                  Text(
                                    babyDueDate,
                                    style: TextStyle(
                                      color: blackColor,
                                      fontSize: 18,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w500,
                                      height: 1.30,
                                      letterSpacing: -0.28,
                                    ),
                                  ),
                                ],
                              ),*/
                              SizedBox(
                                height: 15,
                              ),

                              Padding(
                                //start journey button
                                padding: const EdgeInsets.only(top: 30.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (gender == null) {
                                        showError = true;
                                      } else {
                                        showError = false;
                                      }
                                    });

                                    if (_formKey.currentState!.validate()) {
                                      String babyName =
                                          _babynameController.text.trim();
                                      String? babyGender = gender;

                                      updateBabyInfo(
                                          pregID, babyName, babyGender!);
                                      //Navigator.pop(context, pregID);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BabyInformation(),
                                          settings:
                                              RouteSettings(arguments: pregID),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 75),
                                  ),
                                  child: Text(
                                    "Edit Baby Information",
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            ]),
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
