import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:cool_seat/background/set_alarm.dart';
import 'package:cool_seat/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

Future initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          isForegroundMode: true,
          autoStart: false,
          autoStartOnBoot: false));
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  LocationSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
      forceLocationManager: true,
      intervalDuration: Duration(minutes: 1),
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationTitle: "Location Alert Service",
        notificationText: "Monitoring your location for proximity alerts",
        enableWakeLock: true,
      ));

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  late StreamSubscription<Position> positionStream;

  service.on('fireAlarm').listen((event) async {
    await Alarm.init();
    double latitude = event!['latitude'].toDouble();
    double longitude = event!['longitude'].toDouble();
    int timeInMinutes = event['timeInMinutes'];
    // if i get 0 from the time slider
    timeInMinutes = timeInMinutes == 0 ? 1 : timeInMinutes;

    positionStream =
        Geolocator.getPositionStream().listen((Position? position) {
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
      double distance = Geolocator.distanceBetween(
          latitude, longitude, position!.latitude, position.longitude);
      print(distance);
      print(1500 * timeInMinutes);
      // assuming the car moves at 80 km/hr  which is 1333 meter/min so

      if (distance < 1333 * timeInMinutes) {
        print('distance < 1500');
        setAlarm(dateTime: DateTime.now());
        service.invoke('alarmState', {'alarmState': true});
        positionStream.cancel();
      }
    });
  });
  service.on('stopService').listen((event) async {
    service.stopSelf();
  });
  service.on('stopAlarm').listen((event) async {
    await Alarm.stopAll();
    service.stopSelf();
  });
  service.on('getAlarmState').listen((event) async {
    print('got from the background');
    bool alarmState = await Alarm.isRinging(1);
    service.invoke('alarmState', {'alarmState': alarmState});
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    print('hello');
  });
}
