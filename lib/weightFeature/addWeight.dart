import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/servicemanagement/v1.dart';
import 'package:preggo/colors.dart';

class addWeight extends StatefulWidget {
  late final String userId;

  @override
  State<StatefulWidget> createState() {
    return _fillWeightForm();
  }
}

class _fillWeightForm extends State<addWeight> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _nameKey = GlobalKey<FormFieldState>();
  final TextEditingController _babynameController = TextEditingController();

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  void addWeight(double weight, DateTime dateTime) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userUid = getUserId();

    CollectionReference subCollectionRef = firestore
        .collection('users')
        .doc(userUid)
        .collection('pregnancyInfo')
        .doc("HMEBTKrnOYnmxPmBMHuV")
        .collection('weight');
    subCollectionRef
        .add({
          'dateTime': dateTime,
          'weight': weight,
        })
        .then((value) => print('info added successfully'))
        .catchError((error) => print('failed to add info:$error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backGroundPink,
        body: Column(
          children: [
            SizedBox(),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Appointments",
                  style: TextStyle(
                    color: Color(0xFFD77D7C),
                    fontSize: 32,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
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
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
                                        margin:
                                            EdgeInsets.only(top: 30, left: 5),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: TextFormField(
                                          key: _nameKey,
                                          controller: _babynameController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 15),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              gapPadding: 0.5,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                width: 0.50,
                                                color: Color.fromRGBO(
                                                    255, 100, 100, 1),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              gapPadding: 0.5,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                width: 0.50,
                                                color: Color.fromRGBO(
                                                    255, 100, 100, 1),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              gapPadding: 0.5,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                width: 0.50,
                                                color: Color.fromARGB(
                                                    255, 221, 225, 232),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              // gapPadding: 100,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                width: 0.50,
                                                color: Color.fromARGB(
                                                    255, 221, 225, 232),
                                              ),
                                            ),
                                            hintText: "Optional",
                                            filled: true,
                                            fillColor: Color(0xFFF7F8F9),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
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
                                    ]),
                                  ),
                                ),
                              ]),
                        ))))
          ],
        ));
  }
}
