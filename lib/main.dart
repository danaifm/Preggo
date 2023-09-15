import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:preggo/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
=======
import 'package:preggo/NavBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:preggo/SignUp.dart';
>>>>>>> home_page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        unselectedWidgetColor: Colors.black
      ),
      // the root widget
      home:
<<<<<<< HEAD
          const SplashScreen(), // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
=======
          SignUp(), // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
>>>>>>> home_page
    );
  }
}
