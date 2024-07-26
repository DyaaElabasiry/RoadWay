import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to white
      statusBarIconBrightness: Brightness.light, // Set status bar icons to dark
    ));
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String time = getTime();
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
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
                  padding: const EdgeInsets.all(13),
                  child: Text(time,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 75, color: Colors.white)))),
          Positioned(
              left: width / 2 - 110,
              bottom: height / 2 + 40,
              child: Container(
                  width: 220,
                  height: 60,
                  padding: const EdgeInsets.all(13),
                  child: const Text('Alarm',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: Colors.white)))),
          // Positioned(
          //     left: width / 2 - 110,
          //     bottom: height / 2 - 20,
          //     child: Container(
          //         width: 220,
          //         height: 55,
          //         padding: EdgeInsets.all(13),
          //         decoration: BoxDecoration(
          //           color: Colors.cyan,
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //         child: Text('Snooze for 5 min',
          //             textAlign: TextAlign.center,
          //             style: TextStyle(fontSize: 19, color: Colors.white)))),
          Positioned(
            left: width / 2 - 153,
            bottom: 120-75,
            child: const SpinKitRipple(color: Colors.white, size: 300),),
          Positioned(
              left: width / 2 - 75,
              bottom: 120,
              child: InkWell(
                onTap: () async {
                  FlutterBackgroundService().invoke('stopAlarm');
                  SystemNavigator.pop();
                },
                child: Container(
                    // width: 150,
                    height: 150,
                    padding: const EdgeInsets.all(45),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('stop',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    )),
              )),

        ]),
      ),
    );
  }
}

String getTime() {
  int hour =
      DateTime.now().hour < 13 ? DateTime.now().hour : DateTime.now().hour - 12;
  int minute = DateTime.now().minute;
  String hourString = hour < 10 ? '0$hour' : '$hour';
  String minuteString = minute < 10 ? '0$minute' : '$minute';
  return '$hourString:$minuteString';
}
