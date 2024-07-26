import 'package:flutter/foundation.dart';

class LocationFocus extends ChangeNotifier {
  static final LocationFocus _singleton = LocationFocus._internal();

  factory LocationFocus() {
    return _singleton;
  }

  LocationFocus._internal();

  LocationFocusType locationFocusType = LocationFocusType.current;

  void setLocationFocusType(LocationFocusType focusType) {
    locationFocusType = focusType;
    notifyListeners();
  }
}

enum LocationFocusType { current, destination }