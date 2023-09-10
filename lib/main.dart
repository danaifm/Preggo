import 'package:flutter/material.dart';
import 'package:preggo/NavBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // the root widget
      home:
          NavBar(), // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
    );
  }
}
