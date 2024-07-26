import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';

void setAlarm({required DateTime dateTime}) {
  Alarm.set(
      alarmSettings: AlarmSettings(
        vibrate: true,
        volume: 1,
        id: 1,
        dateTime: dateTime,
        assetAudioPath: 'assets/alarm_samsung.mp3',
        notificationTitle: 'Alarm',
        notificationBody: 'You have reached your destination',
        androidFullScreenIntent: true,
      ));
}