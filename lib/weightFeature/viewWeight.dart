import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/servicemanagement/v1.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/pregnancyInfo.dart';
import 'package:preggo/screens/ToolsPage.dart';
import 'package:preggo/weightFeature/addWeight.dart';
import 'package:preggo/weightFeature/editWeight.dart';
import 'package:intl/intl.dart';

class ViewWeight extends StatefulWidget {
  //final String pregnancyInfo_id;
  const ViewWeight({
    super.key,
  });

  @override
  _ViewWeight createState() => _ViewWeight();
}

class _ViewWeight extends State<ViewWeight> {
  late final String userId;
  // var _numberToMonthMap = {
  //   1: "Jan",
  //   2: "Feb",
  //   3: "Mar",
  //   4: "Apr",
  //   5: "May",
  //   6: "Jun",
  //   7: "Jul",
  //   8: "Aug",
  //   9: "Sep",
  //   10: "Oct",
  //   11: "Nov",
  //   12: "Dec",
  // };

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  // Future<String> getPregnancyInfoId() async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   String userUid = getUserId();

  //     QuerySnapshot pregnancyInfoSnapshot = await firestore
  //         .collection('users')
  //         .doc(userUid)
  //         .collection('pregnancyInfo')
  //         .get();

  //          for (QueryDocumentSnapshot pregnancyDoc in pregnancyInfoSnapshot.docs[0]) {
  //       String Pid = pregnancyDoc.id;
  //       return Pid;
  //     }

  //   }

  //   return pregnancyInfoSnapshot;

  //   // Add a default return statement
  // }

  Future<Widget> getWeight() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    //String Pid = getPregnancyInfoId() as String;
    String userUid = getUserId();

    QuerySnapshot pregnancyInfoSnapshot = await firestore
        .collection('users')
        .doc(userUid)
        .collection('pregnancyInfo')
        .get();

    DocumentSnapshot firstDocument = pregnancyInfoSnapshot.docs[0];
    String Pid = firstDocument.id;

    QuerySnapshot result = await firestore
        .collection('users')
        .doc(userUid)
        .collection('pregnancyInfo')
        .doc(Pid)
        .collection('weight')
        .get();

    print(result.docs.length);
    print('printed');
    if (result.docs.isEmpty) //no weight
    {
      return Container(
        child: Column(
          children: [
            Center(
              //notification bell image
              child: Padding(
                padding: EdgeInsets.only(top: 90),
                child: Image.asset(
                  'assets/images/no-sport.png',
                  height: 90,
                  width: 100,
                ),
              ),
            ),
            Container(
                //message
                margin: EdgeInsets.fromLTRB(30, 35, 30, 80),
                child: Text(
                  'No weight',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.28,
                  ),
                )),
          ],
        ),
      );
    } else {
      //reminders exist for this day
      List weightResult = result.docs;
      // weightResult.sort((a, b) {
      //   String timeA = a.data()['time'] ?? '';
      //   String timeB = b.data()['time'] ?? '';
      //   // Convert 'time' strings to DateTime objects for comparison
      //   DateFormat format = DateFormat("hh:mm a");
      //   DateTime dateTimeA = format.parse(timeA);
      //   DateTime dateTimeB = format.parse(timeB);
      //   return dateTimeB.compareTo(dateTimeA);
      // });
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          height: 505,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: weightResult.length,
            itemBuilder: (context, index) {
              //String id = weightResult[index].data()['id'] ?? '';
              String weight = weightResult[index].data()['weight'] ?? '';
              String dateTime = weightResult[index].data()['dateTime'] ?? '';
              //DateTime date = dateTime.toDate();

              return Container(
                margin: EdgeInsets.all(8),
                //padding: EdgeInsets.all(10),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 17),
                      decoration: BoxDecoration(
                        color: backGroundPink.withOpacity(0.3),
                        border: Border.all(color: backGroundPink, width: 2),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(children: [
                        Container(
                          width: 85,
                          child: Text(
                            '$dateTime',
                            //'${_numberToMonthMap[date.month]} ${date.day} ${date.year} ${date.hour} ${date.minute} ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            '$weight Kg',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ),

                        //delete button
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: GestureDetector(
                            onTap: () {
                              //String documentId = id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => addWeight(),

                                  //settings: RouteSettings(arguments: documentId)
                                ),
                              );
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "delete |",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                              // child: Icon(
                              //   Icons.delete,
                              //   color: Colors.redAccent,
                              //   size: 20,
                              // ),
                            ),
                          ),
                        ),

                        //edit button
                        GestureDetector(
                          onTap: () {
                            //String documentId = id;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => addWeight(),

                                //settings: RouteSettings(arguments: documentId)
                              ),
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "edit ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                            // child: Icon(
                            //   Icons.edit,
                            //   color: Colors.black,
                            //   size: 20,
                            // ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }

  // final _formKey = GlobalKey<FormState>();

  // String? validateWeight(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'This field cannot be empty.';
  //   }
  //   if (value.length > 3 || value.length <= 1) {
  //     return 'Please enter a correct weight.';
  //   }

  //   return null;
  // }

  // void submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     //if form is valid perform the next action
  //     print("The form is validated");
  //   }
  // }

  // openAddDialog(Context) {
  //   //the weight form
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         key: _formKey,
  //         child: Container(
  //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(500)),
  //           height: 150,
  //           child: Padding(
  //             padding: const EdgeInsets.only(top: 20),
  //             child: Column(children: [
  //               Text(
  //                 "Add new weight",
  //                 style: TextStyle(
  //                     fontSize: 20,
  //                     color: blackColor,
  //                     fontWeight: FontWeight.w600),
  //               ),
  //               SizedBox(
  //                 height: 15,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   Container(
  //                     width: 125,
  //                     height: 40,
  //                     child: TextFormField(
  //                         style: TextStyle(fontSize: 15, color: blackColor),
  //                         decoration: InputDecoration(
  //                           hintText: "In Kg",
  //                           border: OutlineInputBorder(
  //                               borderSide:
  //                                   BorderSide(width: 1, color: blackColor)),
  //                         ),
  //                         // The validator receives the text that the user has entered.
  //                         validator: validateWeight),
  //                   ),

  //                   ElevatedButton(
  //                       onPressed: () => {(ViewWeight())},
  //                       child: const Text('Submit')),

  //                   // Container( I need to add a submit button
  //                   //   child: IconButton,
  //                   // )
  //                 ],
  //               )
  //             ]),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundPink,
      // floatingActionButton: Chip(
      //     //the add button
      //     backgroundColor: blackColor,
      //     onDeleted: () => openAddDialog(context),
      //     deleteIcon: Icon(
      //       Icons.add,
      //       color: whiteColor,
      //     ),
      //     label: Text(
      //       "Add weight",
      //       style: TextStyle(fontSize: 20, color: whiteColor),
      //     )),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: blackColor,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "    My weights",
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
                height: 15,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 0.0,
                  ),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(80.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 15),
                    child: Container(
                      child: Column(
                        children: [
                          FutureBuilder<Widget>(
                            future: getWeight(),
                            builder: (BuildContext context,
                                AsyncSnapshot<Widget> snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data!;
                              }
                              return CircularProgressIndicator(
                                  color: pinkColor);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 100, 20, 50),
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => addWeight()))
                      .then((value) {
                    getWeight();
                    setState(() {});
                  });
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(55, 55),
                  shape: const CircleBorder(),
                  backgroundColor: darkBlackColor,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


       //   child: ListView.builder(
                  //     itemCount: 3,
                  //     shrinkWrap: true,
                  //     //physics: NeverScrollableScrollPhysics(),
                  //     itemBuilder: (context, Index) {
                  //       return Padding(
                  //         padding: const EdgeInsets.only(left: 8, top: 8),
                  //         child: Card(
                  //           elevation: 4,
                  //           shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(15)),
                  //           child: ListTile(
                  //             leading: Image(
                  //               height: 50,
                  //               width: 30,
                  //               image: AssetImage("assets/images/dumbbell.png"),
                  //             ),
                  //             title: Text(
                  //               "65 Kg",
                  //               style: TextStyle(
                  //                 fontSize: 28,
                  //                 color: blackColor,
                  //               ),
                  //             ),
                  //             trailing: Icon(
                  //               Icons.delete,
                  //               color: redColor,
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },

                  //     //YOUR WORK GOES HERE
                  //   ),
