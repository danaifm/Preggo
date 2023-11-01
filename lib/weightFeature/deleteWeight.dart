import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/content/v2_1.dart';
import 'package:googleapis/servicemanagement/v1.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/pregnancyInfo.dart';
import 'package:preggo/screens/ToolsPage.dart';
import 'package:preggo/weightFeature/addWeight.dart';
import 'package:preggo/weightFeature/editWeight.dart';
import 'package:preggo/weightFeature/viewWeight.dart';
import 'package:intl/intl.dart';

class deleteWeight extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _deleteWeight();
  }
}

class _deleteWeight extends State<deleteWeight> {
  @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     weightId = ModalRoute.of(context)?.settings.arguments as String;
  //     print("weight id :: $weightId ##");
  //     await DeleteWeight();
  //   });
  // }

  //  String getUserId() {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   return user!.uid;
  // }

  // DeleteWeight() async {
  //   final String userUid = FirebaseAuth.instance.currentUser?.uid ?? "";
  //   log("User Uid :: $userUid #");
  //   if(userUid.isNotEmpty && WeightId.isNotEmpty)
  // }

  Widget build(BuildContext context) {
    // weightid = ModalRoute.of(context)?.settings.arguments as String;
    throw UnimplementedError();
  }
}
