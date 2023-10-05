import 'dart:math' as math;
import 'package:alarm/alarm.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void addReminderToSystem({
  required DateTime dateTime,
  required String title,
  required String body,
}) async {
  final alarmSettings = AlarmSettings(
    id: 42,
    dateTime: dateTime,
    assetAudioPath: 'assets/alarm.wav',
    loopAudio: true,
    vibrate: true,
    volumeMax: true,
    fadeDuration: 3.0,
    notificationTitle: title,
    notificationBody: body,
    enableNotificationOnKill: true,
  );

  await Alarm.set(alarmSettings: alarmSettings);
}

Future<void> scheduleRepeatingAlarms({
  required String title,
  required String dayStr,
  required int hour,
  required int minute,
  required DateTime date,
  bool repeat = true,
}) async {
  final day = int.parse(dayStr);
  String localTimeZone =
  await AwesomeNotifications().getLocalTimeZoneIdentifier();

  int daysUntilNextDay = (day - date.weekday + 7) % 7;
  DateTime nextTime = DateTime(
    date.year,
    date.month,
    date.day + daysUntilNextDay,
    hour,
    minute,
  );

  if (nextTime.isBefore(DateTime.now())) {
    nextTime = nextTime.add(const Duration(days: 7));
  }

  int nextTimeInSeconds = nextTime.difference(DateTime.now()).inSeconds;
  const int maxInt32 = 0x7FFFFFFF;
  int uniqueId =
      generateUniqueNumericId() % (maxInt32 + math.Random().nextInt(5));

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: uniqueId,
      channelKey: 'channel_id',
      title: title,
    ),
    schedule: NotificationInterval(
      interval: nextTimeInSeconds,
      timeZone: localTimeZone,
      repeats: repeat,
    ),
  );
}

int generateUniqueNumericId() {
  final int timestamp = DateTime.now().millisecondsSinceEpoch;
  final int randomPart = math.Random()
      .nextInt(999999); // Generate a random number between 0 and 999999
  final int uniqueDeviceId = math.Random().nextInt(20);

  final int uniqueId = timestamp + randomPart + uniqueDeviceId;
  return uniqueId;
}

Future<void> getRemainders() async {
  final data = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('reminders')
      .get();

  for (var element in data.docs) {
    final data = element.data();
    for (var e in (data['repeat'] as List<dynamic>)) {
      final int year = int.parse(data['date'].split('-')[2]);
      final int month = int.parse(data['date'].split('-')[0]);
      final int day = int.parse(data['date'].split('-')[1]);

      await scheduleRepeatingAlarms(
        title: data['title'],
        dayStr: e['id'],
        date: DateTime(year, month, day),
        hour: int.parse(data['time'].split(':')[0]),
        minute: int.parse(data['time'].split(':')[1].split(' ')[0]),
        repeat: (data['repeat'] as List).isNotEmpty,
      );
    }
  }
}