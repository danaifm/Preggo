import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:preggo/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:preggo/NavBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:preggo/SignUp.dart';
import 'package:preggo/reminder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Alarm.init();
  //addReminderToSystem(dateTime: DateTime(2023,10,3,14,54), title: 'Title', body: 'Body');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: false,
          fontFamily: "Urbanist",
          unselectedWidgetColor: Colors.black),
      // the root widget
      home:
          const SplashScreen(), // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
    );
  }
}
