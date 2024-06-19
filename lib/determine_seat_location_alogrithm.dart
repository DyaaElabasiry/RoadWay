import 'package:apsl_sun_calc/apsl_sun_calc.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

void getSeatLocation(DateTime date , LatLng location,LatLng currentLocation,LatLng destinationLocation){
  var sunPosition = SunCalc.getSunPosition(date,location.latitude, location.longitude);
  double  azimuth = sunPosition['azimuth']! * 180 / math.pi;
  double altitude = sunPosition['altitude']! * 180 / math.pi;
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

}