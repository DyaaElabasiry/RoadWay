import 'dart:math';

import 'package:flutter/material.dart';

class CarBoxLeftSunRay extends StatelessWidget {
  final double sunRayAngle;
  final String timeTitle;

  const CarBoxLeftSunRay({super.key, required this.sunRayAngle, required this.timeTitle});
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 130,
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),

                  ),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_seat,
                            color: Colors.black,
                            size: 80,
                          ),
                        ],
                      ),
                    ),
                    ClipPath(
                      clipper: SunRayPath(sunRayAngle: sunRayAngle),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.yellowAccent,
                              Colors.yellow.withOpacity(0.07)
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_seat,
                      color: Colors.black,
                      size: 80,
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
        Positioned(
          top: 0,
          left: 10,
          child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  // BoxShadow(
                  //   color: Colors.yellow.withOpacity(0.2),
                  //   spreadRadius: 5,
                  //   blurRadius: 7,
                  //   offset: Offset(0, 3),
                  // ),
                ],
              ),
              child: Icon(
                Icons.sunny,
                color: Colors.orangeAccent,
                size: 30,
              )),
        ),
        Positioned(
          top: -5,
          left: 55,
          child: Text(
            timeTitle,
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

class SunRayPath extends CustomClipper<Path> {
  final double sunRayAngle;

  SunRayPath({super.reclip, required this.sunRayAngle});
  
  @override
  Path getClip(Size size) {
    final Path path = Path();
    double tanAngle = tan(sunRayAngle * pi / 180);
    path.moveTo(0, 0);
    for (double x = 0; x <= size.width; x++) {
      double y = tanAngle * x;
      path.lineTo( x, y);
    }
    // Complete the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
