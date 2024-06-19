import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationController {

  static final LocationController _singleton = LocationController
      ._internal();

  factory LocationController() {
    return _singleton;
  }

  LocationController._internal();

  LatLng? currentLocation ;
  LatLng? destinationLocation ;
  double locationFocus=0;

  List<Marker> currentDestinationMarkersList = [const Marker(
    width: 0,
    height: 0,
    point: LatLng(0, 0),
    child: SizedBox(),
  ),const Marker(
    width: 0,
    height: 0,
    point: LatLng(0, 0),
    child: SizedBox(),
  )
  ];

  void setCurrentLocation(LatLng latLng) {
    currentLocation = latLng;
    currentDestinationMarkersList[0] = Marker(
      width: 23,
      height: 23,
      point: latLng,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.redAccent, width: 7),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }
  void setDestinationLocation(LatLng latLng) {
    destinationLocation = latLng;
    currentDestinationMarkersList[1] = Marker(
      width: 23,
      height: 23,
      point: latLng,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blueAccent, width: 7),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }
}