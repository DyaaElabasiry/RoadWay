import 'package:latlong2/latlong.dart';
import 'package:open_meteo/open_meteo.dart';

Future<WeatherResult> getWeather({required LatLng location}) async {
  var weather = Weather(
      latitude: location.latitude,
      longitude: location.longitude,
      temperature_unit: TemperatureUnit.celsius);
  var hourly = [Hourly.temperature_2m, Hourly.relative_humidity_2m];
  Map result = await weather.raw_request(hourly: hourly);

  Map data = result['hourly'];
  List allTemp = data['temperature_2m'];
  List allHumidity = data['relative_humidity_2m'];
  int currentHour = DateTime.now().hour;
  double temp = allTemp[currentHour] ;
  int humidity = allHumidity[currentHour];
  return WeatherResult(temperature: temp,humidity: humidity);
}
class WeatherResult{
  final double temperature;
  final int humidity;
  WeatherResult({required this.temperature,required this.humidity});
}