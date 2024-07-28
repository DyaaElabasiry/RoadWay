import 'dart:async';

import 'dart:ui';
import 'package:alarm/alarm.dart';
import 'package:RoadWay/background/set_alarm.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
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




  late StreamSubscription<Position> positionStream;

  service.on('fireAlarm').listen((event) async {
    await Alarm.init();
    LocationSettings locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(minutes: 1),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: "Location Monitoring Active",
          notificationText: "Your location is being monitored to alert you when you reach your destination",
          enableWakeLock: true,
        ));
    double latitude = event!['latitude'].toDouble();
    double longitude = event!['longitude'].toDouble();
    int timeInMinutes = event['timeInMinutes'];
    // if i get 0 from the time slider
    timeInMinutes = timeInMinutes == 0 ? 1 : timeInMinutes;
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
      double distance = Geolocator.distanceBetween(
          latitude, longitude, position!.latitude, position.longitude);
      // assuming the car moves at 80 km/hr  which is 1333 meter/min so

      if (distance < 1333 * timeInMinutes) {
        setAlarm(dateTime: DateTime.now());
        service.invoke('alarmState', {'alarmState': true});
        positionStream.cancel();
      }
    });
  });
  service.on('stopService').listen((event) async {
    positionStream.cancel();
    service.stopSelf();
  });
  service.on('stopAlarm').listen((event) async {
    await Alarm.stopAll();
    service.stopSelf();
  });
  service.on('getAlarmState').listen((event) async {
    bool alarmState = await Alarm.isRinging(1);
    service.invoke('alarmState', {'alarmState': alarmState});
  });

}
