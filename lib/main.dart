import 'package:flutter/material.dart';
import 'package:preggo/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // the root widget
      home:
          SplashScreen(), // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
    );
  }
}
