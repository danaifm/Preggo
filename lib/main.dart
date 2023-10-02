import 'package:flutter/material.dart';
import 'package:preggo/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:preggo/NavBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:preggo/SignUp.dart';
import 'package:preggo/viewAppointment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // the root widget
      home:
          viewAppointment(), // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
    );
  }
}
