import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),

      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.actionId == 'stop_alarm_action') {
          print('Action One Clicked');
          Alarm.stopAll();
        }
        Alarm.stopAll();
      },
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          isForegroundMode: true,
          autoStart: false,
          autoStartOnBoot: false));
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async{
  DartPluginRegistrant.ensureInitialized();
  await Alarm.init();
  await AndroidAlarmManager.initialize();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) async{
    service.stopSelf();
  });
  service.on('fireAlarm').listen((event) async{
    AndroidAlarmManager.oneShot(Duration(seconds: 5), 33, (){},alarmClock: true, wakeup: true);
  });

  // bring to foreground
  Alarm.set(alarmSettings: AlarmSettings(
    vibrate: false,
    volume: 0.2,
    id: 1,
    dateTime: DateTime.now().add(const Duration(seconds: 5)),
    assetAudioPath: 'assets/alarm_samsung.mp3',
    notificationBody: 'body',
    notificationTitle: 'title',
    androidFullScreenIntent: true,
  )
  );
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    print('hello');
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.
        flutterLocalNotificationsPlugin.show(
          888,
          'Forground Service',
          '${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
              actions: <AndroidNotificationAction>[
                AndroidNotificationAction(
                  'stop_alarm_action',
                  'Stop Alarm',
                  showsUserInterface: true,
                ),
              ],
            ),
          ),
        );
      } else {
        flutterLocalNotificationsPlugin.show(
          888,
          'Background Service',
          '${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
      }
    }
  });

}
