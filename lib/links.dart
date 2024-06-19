import 'dart:async';
import 'package:cool_seat/database%20helper.dart';
import 'package:http_client/console.dart';

class LinkHelper {
  static final LinkHelper _instance = LinkHelper._internal();

  factory LinkHelper() {
    return _instance;
  }
  LinkHelper._internal();


  Future<Map<String,String?>?> getCoordinates(String url) async {

    try {
      final client = ConsoleClient();
      final rs = await client.send(Request('HEAD', url ,followRedirects: false));
      // rs.redirects!.forEach((element) {
      //   print(element.location);
      // });
      final textContent = await rs.headers.toMap()['location']![0];

      await client.close();
      print(textContent)  ;
      RegExp coordinates = RegExp(r'@(\d+\.?\d+),(\d+\.?\d+)');
      RegExpMatch? match = coordinates.firstMatch(textContent);
      print( {'latitude': match?.group(1), 'longitude': match?.group(2)});
    } on Exception catch (e) {
      print('an error occured $e');
      return null;
    }
  }
}