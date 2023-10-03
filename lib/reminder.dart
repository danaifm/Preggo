import 'package:alarm/alarm.dart';

void addReminderToSystem({
  required DateTime dateTime,
  required String title,
  required String body,
}) async {
  final alarmSettings = AlarmSettings(
    id: 42,
    dateTime: dateTime,
    assetAudioPath: 'assets/alarm.mp3',
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
