import 'package:flutter/material.dart';
import 'package:preggo/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
=======
import 'package:preggo/start_Journey.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
>>>>>>> pregnancy_info
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: "Urbanist",
      ),
      // the root widget
      home:
          const SplashScreen(), // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
=======
      theme: ThemeData(unselectedWidgetColor: Colors.black),
      debugShowCheckedModeBanner: false,

      // the root widget
      home:
          startJourney(), // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
>>>>>>> pregnancy_info
    );
  }
}
