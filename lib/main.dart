import 'package:flutter/material.dart';
import 'package:preggo/SignUp.dart';
import 'package:preggo/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:preggo/SignUp.dart';
import 'package:string_validator/string_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
      home: SplashScreen(),
      // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
    );
  }
}
