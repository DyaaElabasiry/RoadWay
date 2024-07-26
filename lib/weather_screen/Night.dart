import 'dart:math';

import 'package:flutter/material.dart';

class NightBox extends StatelessWidget {
  final String timeTitle;

  const NightBox({super.key, required this.timeTitle});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 130,
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(35, 35, 41, 1),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.nightlight_round, color: Colors.white, size: 80),
              Center(
                child: Text(
                  "It's night time\nenjoy your ride",
                  style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                )
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 40,
          child: Text(
            timeTitle,
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
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
    path.moveTo(size.width, 0);
    for (double x = 0; x <= size.width; x++) {
      double y = tanAngle * x;
      path.lineTo(size.width - x, y);
    }
    // Complete the rectangle
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
