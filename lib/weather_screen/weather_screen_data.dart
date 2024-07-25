import 'package:cool_seat/current_destination_location_helper.dart';
import 'package:cool_seat/weather_screen/get_weather.dart';
import 'package:cool_seat/location_service.dart';
import 'package:latlong2/latlong.dart';

import '../determine_sun_location_alogrithm.dart';

class WeatherScreenData {
  // Variables to store weather data
  WeatherResult? weatherNow;
  SunLocationResult? sunLocationNow;
  SunLocationResult? sunLocationAfterOneHour;
  SunLocationResult? sunLocationAfterTwoHours;

  // Private constructor
  WeatherScreenData._privateConstructor();

  // Static final instance
  static final WeatherScreenData _instance =
      WeatherScreenData._privateConstructor();

  // Factory constructor to return the instance
  factory WeatherScreenData() {
    return _instance;
  }

  Future loadWeatherData(
      LatLng currentLocation, LatLng destinationLocation) async {
    // Load weather data
    this.weatherNow = await getWeather(location: currentLocation);
    // Load sun location data
    this.sunLocationNow = getSunLocation(
        DateTime.now(), currentLocation, currentLocation, destinationLocation);
    this.sunLocationAfterOneHour = getSunLocation(
        DateTime.now().add(Duration(hours: 1)),
        currentLocation,
        currentLocation,
        destinationLocation);
    this.sunLocationAfterTwoHours = getSunLocation(
        DateTime.now().add(Duration(hours: 2)),
        currentLocation,
        currentLocation,
        destinationLocation);
  }
}
