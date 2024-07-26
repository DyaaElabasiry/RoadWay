import 'package:apsl_sun_calc/apsl_sun_calc.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

SunLocationResult getSunLocation(DateTime date , LatLng location,LatLng currentLocation,LatLng destinationLocation){
  var sunPosition = SunCalc.getSunPosition(date,location.latitude, location.longitude);  // altitude and azimuth of the sun
  double  azimuth = sunPosition['azimuth']! * 180 / math.pi;
  double altitude = sunPosition['altitude']! * 180 / math.pi;
  SunDirection sunDirection = SunDirection.night;  // right or left of the rider
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
  // getting the vector from current location to destination location

  double x = destinationLocation.longitude - currentLocation.longitude;
  double y = destinationLocation.latitude - currentLocation.latitude;

  double angle = math.atan2(y, x) * 180 / math.pi;
  if(angle<0){
    angle = 360 + angle;
  }
  double angleDifference = angle - azimuth;

  if (altitude>7){
    if(angleDifference>0){
      if(angleDifference<180) {
        sunDirection = SunDirection.right;
      }else{
        sunDirection = SunDirection.left;
        angleDifference = 360 - angleDifference;
      }
    }else{
      if(angleDifference>-180) {
        sunDirection = SunDirection.left;
      }else{
        sunDirection = SunDirection.right;
        angleDifference = 360 + angleDifference;
      }
    }
  }

  if(angleDifference<20 && angleDifference>160) {
    sun_intensity = 'Low';
  }else{
    sun_intensity = 'High';
  }
  return SunLocationResult(sunDirection, altitude);
}

enum SunDirection{
  right,
  left,
  night

}

class SunLocationResult {
  final SunDirection sunDirection;
  final double altitude;

  SunLocationResult(this.sunDirection, this.altitude);
}