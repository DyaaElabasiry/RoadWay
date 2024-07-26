import 'dart:async';
import 'package:RoadWay/alarm_screen.dart';
import 'package:RoadWay/database/database%20helper.dart';
import 'package:RoadWay/maps_screen/maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'background/background_process.dart';


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
      home: const MyHomePage(),
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
    return alarmState ? const AlarmScreen() : const OSMScreen();
  }
}
