import 'package:cool_seat/car_right_sunray_widget.dart';
import 'package:cool_seat/current_destination_location_helper.dart';
import 'package:cool_seat/determine_seat_location_alogrithm.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

import 'car_left_sunray_widget.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> with TickerProviderStateMixin {

  late AnimationController _controller1;
  late Animation<Offset> _animation1;

  late AnimationController _controller2;
  late Animation<Offset> _animation2;

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

    // Start the animations with a delay
    _controller1.forward();
    _controller2.forward();
  }
  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to white
      statusBarIconBrightness: Brightness.light, // Set status bar icons to dark
    ));
    // LocationController locationController = LocationController();
    // LatLng? currentLocation = locationController.currentLocation;
    // LatLng? destinationLocation = locationController.destinationLocation;
    // List data = getSeatLocation(DateTime.now(), currentLocation!, currentLocation!, destinationLocation!);
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 250, 1),
      body: Column(
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
                              padding: const EdgeInsets.only(left: 20,top: 55),
                              child: InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_back_ios, color: Colors.white, size: 25,),
                                    Text('  Weather', style: TextStyle(color: Colors.white, fontSize: 25),),
                                  ],
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 55,top: 50),
                              child: Row(
                                children: [
                                  Icon(Icons.thermostat, color: Colors.white, size: 25,),
                                  Text(' 25°', style: TextStyle(color: Colors.white, fontSize: 50,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 55,top: 15),
                              child: Row(
                                children: [
                                  Icon(Icons.water_drop_outlined, color: Colors.white, size: 25,),
                                  Text(' 50%', style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ],

                        ),
                      ),
                      Expanded(child: Image.asset('assets/images/sun.png', height: 150, width: 150,)),
                    ],
                  )
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Text('Sun position', style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold),),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
          //   child: Text('Now', style: TextStyle(color: Colors.black, fontSize: 20,),),
          // ),
          SlideTransition(
            position: _animation1,

              child: CarBoxRightSunRay()),
          SizedBox(height: 20,),
          SlideTransition(
              position: _animation2,
              child: CarBoxLeftSunRay()),
        ],
      ),
    );
  }
}
class BackgroundSineWaveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double amplitude = 20 ;
    final double frequency =0.56 ;
    double x = size.width*0.35 ;
    double y = size.height-20 + amplitude*sin(0.7*x*pi/180) ;
    path.moveTo(x, y);
    for(double x=size.width*0.35 ;x<= size.width ; x++ ){
      double y = size.height-20 + amplitude*sin(frequency*x*pi/180);
      path.lineTo(x, y);
    }
    // Complete the rectangle
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height-20);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper)=> false ;

}
class SineWaveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double amplitude = 20 ;
    final double frequency =0.7 ;

    path.moveTo(0, size.height-20);
    for(double x=0;x<= size.width ; x++ ){
      double y = size.height-20 + amplitude*sin(frequency*x*pi/180);
      path.lineTo(x, y);
    }
    // Complete the rectangle
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper)=> false ;

}