import 'package:flutter/material.dart';
import 'dart:math';


class BackgroundSineWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double amplitude = 20;
    const double frequency = 0.56;
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
    const double amplitude = 20;
    const double frequency = 0.7;

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