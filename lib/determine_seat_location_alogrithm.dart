import 'package:apsl_sun_calc/apsl_sun_calc.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

void getSeatLocation(DateTime date , LatLng location,LatLng currentLocation,LatLng destinationLocation){
  var sunPosition = SunCalc.getSunPosition(date,location.latitude, location.longitude);  // altitude and azimuth of the sun
  double  azimuth = sunPosition['azimuth']! * 180 / math.pi;
  double altitude = sunPosition['altitude']! * 180 / math.pi;
  String sun_position = '';  // right or left of the rider
  String sun_intensity = '';  // high or low
  // converting azimuth to 0-360
  if(azimuth>=0){
    azimuth = 270 - azimuth;
  }else{
    azimuth =  -azimuth;
    azimuth = 270 + azimuth;
    if(azimuth>=360){
      azimuth = azimuth - 360;
    }
  }

  double x = destinationLocation.longitude - currentLocation.longitude;
  double y = destinationLocation.latitude - currentLocation.latitude;

  double angle = math.atan2(y, x) * 180 / math.pi;
  if(angle<0){
    angle = 360 + angle;
  }
  double angleDifference = angle - azimuth;
  if(angleDifference>0){
    if(angleDifference<180) {
      sun_position = 'Right';
    }else{
      sun_position = 'Left';
      angleDifference = 360 - angleDifference;
    }
  }else{
    if(angleDifference>-180) {
      sun_position = 'Left';
    }else{
      sun_position = 'Right';
      angleDifference = 360 + angleDifference;
    }
  }

  if(angleDifference<20 && angleDifference>160) {
    sun_intensity = 'Low';
  }else{
    sun_intensity = 'High';
  }
  print('Sun Position: $sun_position and Sun Intensity: $sun_intensity');
}