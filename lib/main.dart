import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:cool_seat/alarm_screen.dart';
import 'package:cool_seat/current_destination_location_helper.dart';
import 'package:cool_seat/database%20helper.dart';
import 'package:cool_seat/deep_link.dart';
import 'package:cool_seat/last_feature.dart';
import 'package:cool_seat/links.dart';
import 'package:cool_seat/maps_screen/maps_screen.dart';
import 'package:cool_seat/sqflite_test.dart';
import 'package:cool_seat/weather_screen/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:apsl_sun_calc/apsl_sun_calc.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'background/background_process.dart';
import 'package:sqflite/sqflite.dart';
import 'background/background_process.dart';
import 'location_focus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the database
  DatabaseHelper database = DatabaseHelper();
  await database.init();
  await initializeBackgroundService();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  bool alarmState = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RoadWay',
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
  bool alarmState = false;
  late StreamSubscription alarmStateSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterBackgroundService().invoke('getAlarmState');
    alarmStateSubscription = FlutterBackgroundService().on('alarmState').listen((event) {
      if (mounted) {
        setState(() {
          alarmState = event!['alarmState'];
        });
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    alarmStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return alarmState ? AlarmScreen() : OSMScreen();
  }
}
