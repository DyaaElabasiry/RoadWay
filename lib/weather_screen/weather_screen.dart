import 'package:cool_seat/weather_screen/Night.dart';
import 'package:cool_seat/weather_screen/car_right_sunray_widget.dart';
import 'package:cool_seat/current_destination_location_helper.dart';
import 'package:cool_seat/determine_sun_location_alogrithm.dart';
import 'package:cool_seat/weather_screen/weather_screen_data.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

import 'car_left_sunray_widget.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late Animation<Offset> _animation1;

  late AnimationController _controller2;
  late Animation<Offset> _animation2;

  late AnimationController _controller3;
  late Animation<Offset> _animation3;

  @override
  void initState() {
    super.initState();

    // First widget
    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation1 = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller1,
      curve: Curves.easeOut,
    ));

    // Second widget
    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation2 = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller2,
      curve: Curves.easeOut,
    ));

    _controller3 = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation3 = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller3,
      curve: Curves.easeOut,
    ));

    // Start the animations with a delay
    _controller1.forward();
    _controller2.forward();
    _controller3.forward();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to white
      statusBarIconBrightness: Brightness.light, // Set status bar icons to dark
    ));
    WeatherScreenData weatherScreenData = WeatherScreenData();
    double temperature = weatherScreenData.weatherNow!.temperature;
    int humidity = weatherScreenData.weatherNow!.humidity;
    SunLocationResult sunLocationNow = weatherScreenData.sunLocationNow!;
    SunLocationResult sunLocationAfterOneHour =
        weatherScreenData.sunLocationAfterOneHour!;
    SunLocationResult sunLocationAfterTwoHours =
        weatherScreenData.sunLocationAfterTwoHours!;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 250, 1),
      body: SizedBox(
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                ClipPath(
                  clipper: BackgroundSineWaveClipper(),
                  child: Container(
                    color: Colors.grey,
                    height: 375,
                    width: double.maxFinite,
                  ),
                ),
                ClipPath(
                  clipper: SineWaveClipper(),
                  child: Container(
                      height: 375,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black87,
                            Colors.black45,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 55),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                        Text(
                                          '  Weather',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.thermostat,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      Text(
                                        ' ${temperature}°',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.water_drop_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      Text(
                                        ' ${humidity}%',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Image.asset(
                            'assets/images/sun.png',
                            height: 150,
                            width: 150,
                          )),
                        ],
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Text(
                'Sun position',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SlideTransition(
                      position: _animation1,
                      child: getCarBox(
                          sunLocation: sunLocationNow, timeTitle: 'Now'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SlideTransition(
                        position: _animation2,
                        child: getCarBox(
                            sunLocation: sunLocationAfterOneHour,
                            timeTitle: 'After 1 hour')),
                    SizedBox(
                      height: 20,
                    ),
                    SlideTransition(
                        position: _animation3,
                        child: getCarBox(
                            sunLocation: sunLocationAfterTwoHours,
                            timeTitle: 'After 2 hours')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundSineWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double amplitude = 20;
    final double frequency = 0.56;
    double x = size.width * 0.35;
    double y = size.height - 20 + amplitude * sin(0.7 * x * pi / 180);
    path.moveTo(x, y);
    for (double x = size.width * 0.35; x <= size.width; x++) {
      double y = size.height - 20 + amplitude * sin(frequency * x * pi / 180);
      path.lineTo(x, y);
    }
    // Complete the rectangle
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 20);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class SineWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double amplitude = 20;
    final double frequency = 0.7;

    path.moveTo(0, size.height - 20);
    for (double x = 0; x <= size.width; x++) {
      double y = size.height - 20 + amplitude * sin(frequency * x * pi / 180);
      path.lineTo(x, y);
    }
    // Complete the rectangle
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

Widget getCarBox(
    {required SunLocationResult sunLocation, required String timeTitle}) {
  if (sunLocation.sunDirection == SunDirection.right) {
    return CarBoxRightSunRay(
        sunRayAngle: sunLocation.altitude, timeTitle: timeTitle);
  } else if (sunLocation.sunDirection == SunDirection.left) {
    return CarBoxLeftSunRay(
        sunRayAngle: sunLocation.altitude, timeTitle: timeTitle);
  } else {
    return NightBox( timeTitle: timeTitle);
  }
}
