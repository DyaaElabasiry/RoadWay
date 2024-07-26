import 'dart:async';
import 'package:latlong2/latlong.dart';

class LinkHelper {
  static final LinkHelper _instance = LinkHelper._internal();

  factory LinkHelper() {
    return _instance;
  }
  LinkHelper._internal();


  Future<LatLng?> getCoordinates(String url) async {

    try {
      // final client = ConsoleClient();
      // final rs = await client.send(Request('GET', url ,followRedirects: false));
      // final textContent = rs.headers.toMap()['location']![0];
      //
      // await client.close();
      // print(textContent)  ;
      // print('77777777777777777777777777777');
      RegExp coordinates = RegExp(r'@(\d+\.?\d+),(\d+\.?\d+)');
      RegExpMatch? match = coordinates.firstMatch(url);
      double latitude = double.parse(match?.group(1) ?? '0');
      double longitude = double.parse(match?.group(2) ?? '0');
      return LatLng(latitude, longitude);
    } on Exception catch (e) {
      return null;
    }
  }
}