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

class ContractionT extends StatefulWidget {
  late DocumentReference _documentReference;

  //final String pregnancyInfo_id;
  ContractionT({
    super.key,
  });

  @override
  _ContractionT createState() => _ContractionT();
}

class _ContractionT extends State<ContractionT> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backGroundPink,
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                height: 40,
              ),
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
                    "Contraction timer",
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
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8, 200, 8, 3),
                      height: 400,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 246, 241, 241),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   margin: EdgeInsets.all(8),
              //   height: 400,
              //   decoration: BoxDecoration(color: Color(0xFF323F68)),
              // )
            ],
          ),
        ]));
  }
}
