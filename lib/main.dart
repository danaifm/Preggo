import 'package:flutter/material.dart';
import 'package:preggo/NavBar.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // the root widget
      home:
          NavBar(), // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
    );
  }
}
