import 'dart:io';

import 'package:cool_seat/last_feature.dart';
import 'package:cool_seat/maps_screen/maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class AlarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String time = getTime();
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomCenter,
            radius: 1.1,
            focal: Alignment.bottomCenter,
            colors: [Color.fromRGBO(227, 41, 56, 1), Colors.black],
          ),
        ),
        child: Stack(children: [
          Positioned(
              left: width / 2 - 110,
              top: height / 10,
              child: Container(
                  width: 220,
                  height: 150,
                  padding: EdgeInsets.all(13),
                  child: Text(time,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 75, color: Colors.white)))),
          Positioned(
              left: width / 2 - 110,
              bottom: height / 2 + 40,
              child: Container(
                  width: 220,
                  height: 60,
                  padding: EdgeInsets.all(13),
                  child: Text('Alarm',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: Colors.white)))),
          Positioned(
              left: width / 2 - 110,
              bottom: height / 2 - 20,
              child: Container(
                  width: 220,
                  height: 55,
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Snooze for 5 min',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 19, color: Colors.white)))),
          Positioned(
              left: width / 2 - 75,
              bottom: 50,
              child: InkWell(
                onTap: () async{
                  FlutterBackgroundService().invoke('stopAlarm');
                  SystemNavigator.pop();
                },
                child: Container(
                    width: 150,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('stop',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20))),
              ))
        ]),
      ),
    );
  }
}

String getTime(){
  int hour = DateTime.now().hour < 13 ? DateTime.now().hour : DateTime.now().hour - 12;
  int minute = DateTime.now().minute;
  String hourString = hour < 10 ? '0$hour' : '$hour';
  String minuteString = minute < 10 ? '0$minute' : '$minute';
  return '$hourString:$minuteString';
}
