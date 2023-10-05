import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:preggo/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:preggo/colors.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().requestPermissionToSendNotifications();
  AwesomeNotifications().initialize(
    null,
    debug: true,
    [
      NotificationChannel(
        channelKey: 'channel_id',
        channelName: 'channel_id',
        channelDescription: 'test',
        playSound: true,
        channelShowBadge: true,
        importance: NotificationImportance.High,
        criticalAlerts: true,
      ),
    ],
  );
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: pinkColor,
        ),
        unselectedWidgetColor: Colors.black,
      ),
      // the root widget
      home:
          const SplashScreen(), // each class representes a page or a screen, if you want to display the login class(page) you just call it form here
    );
  }
}