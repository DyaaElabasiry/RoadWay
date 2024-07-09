import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:cool_seat/background_process.dart';
import 'package:cool_seat/links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class DeepLinkTestWidget extends StatefulWidget {
  @override
  State<DeepLinkTestWidget> createState() => _DeepLinkTestWidgetState();
}

class _DeepLinkTestWidgetState extends State<DeepLinkTestWidget> {
  LinkHelper linkHelper = LinkHelper();
  String link = '';
  String longitude = '';
  String latitude = '';

  // @override
  // void initState() {
  //   super.initState();

  //   ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) async{
  //     print('Shared ${value[0].type}');
  //     print('Shared ${value[0].path}');
  //     link = value[0].path;
  //     print(link);
  //       linkHelper.getCoordinates(link);
  //       showAlertDialog(context, link);
  //
  //     // linkHelper.getCoordinates(link);
  //     print('2');
  //     print('2');
  //     print('2');
  //     print('2');
  //     print('2');
  //     print('2');
  //   });
  // }
  //   final alarmSettings = AlarmSettings(
  //     id: 33,
  //     dateTime: DateTime.now().add(Duration(seconds: 5)),
  //     loopAudio: true,
  //     vibrate: true,
  //     volume: 0.8,
  //     fadeDuration: 3.0,
  //     notificationTitle: 'This is the title',
  //     notificationBody: 'This is the body', assetAudioPath: 'assets/alarm_samsung.mp3',
  //     androidFullScreenIntent: true,
  //     enableNotificationOnKill: true,
  //
  //
  //   );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm'),
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                FlutterBackgroundService().invoke('fireAlarm');
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'new alarm ,manager plus',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                FlutterBackgroundService().invoke('setAsForeground');
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'set forground service',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                FlutterBackgroundService().invoke('setAsBackground');
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'set as background',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                FlutterBackgroundService().invoke('stopService');
                FlutterLocalNotificationsPlugin().cancelAll();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'stop service',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                FlutterBackgroundService().startService();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'start service',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Future.delayed(Duration(seconds: 5), () {
                  FlutterLocalNotificationsPlugin().show(
                      33,
                      'title',
                      'body',
                      NotificationDetails(
                        android: AndroidNotificationDetails(
                          'my_foreground',
                          'MY FOREGROUND SERVICE',
                          priority: Priority.high,
                          importance: Importance.high,
                          fullScreenIntent: true,
                          playSound: true,
                          actions: <AndroidNotificationAction>[
                            AndroidNotificationAction(
                              'action_one',
                              'Action One',
                              showsUserInterface: true,
                            ),
                            AndroidNotificationAction(
                              'action_two',
                              'Action Two',
                              showsUserInterface: true,
                            ),
                          ],
                        ),
                      ));
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'show notification',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            InkWell(
              onTap: () {

                  Alarm.stopAll();

              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Stop Alarm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
