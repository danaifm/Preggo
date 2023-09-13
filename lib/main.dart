import 'package:flutter/material.dart';
import 'package:preggo/SplashScreen.dart';
import 'package:preggo/login_screen.dart';
import 'package:preggo/pregnancyInfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:preggo/start_Journey.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(unselectedWidgetColor: Colors.black),
      debugShowCheckedModeBanner: false,

      // the root widget
      home:
          startJourney(), // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
    );
  }
}
