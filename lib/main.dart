import 'package:flutter/material.dart';
import 'package:preggo/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // the root widget
      home: SplashScreen(),
      // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
    );
  }
}
