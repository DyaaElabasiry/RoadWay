import 'package:cool_seat/database%20helper.dart';
import 'package:cool_seat/deep_link.dart';
import 'package:cool_seat/links.dart';
import 'package:cool_seat/maps_screen.dart';
import 'package:cool_seat/sqflite_test.dart';
import 'package:cool_seat/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:apsl_sun_calc/apsl_sun_calc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the database
  DatabaseHelper database = DatabaseHelper();
  database.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to white
      statusBarIconBrightness: Brightness.dark, // Set status bar icons to dark
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hot Seat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
      // const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    var sunPosition = SunCalc.getSunPosition(DateTime.now(),69, -72);
    double  azimuth = sunPosition['azimuth']! * 180 / math.pi;
    double altitude = sunPosition['altitude']! * 180 / math.pi;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${azimuth}     ${altitude}'

              ,
            ),

          ],
        ),
      ),

    );
  }
}
