import 'package:cool_seat/links.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';


class DeepLinkTestWidget extends StatefulWidget {
  @override
  State<DeepLinkTestWidget> createState() => _DeepLinkTestWidgetState();
}

class _DeepLinkTestWidgetState extends State<DeepLinkTestWidget> {
  LinkHelper linkHelper = LinkHelper();
  String link = '';
  String longitude = '';
  String latitude = '';


  @override
  void initState() {
    super.initState();

    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) async{
      print('Shared ${value[0].type}');
      print('Shared ${value[0].path}');
      link = value[0].path;
      Future.delayed(Duration(seconds: 3), (){
        linkHelper.getCoordinates(link);
      });
      // linkHelper.getCoordinates(link);
      print('2');
      print('2');
      print('2');
      print('2');
      print('2');
      print('2');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deep Link Test'),
      ),
      body: Column(
        children: [
          TextButton(onPressed: (){
            linkHelper.getCoordinates('https://maps.app.goo.gl/A7A65LhAud9GFiuh6');
          }, child: Text('Get coordinates')),
          Center(
            child: Text('Deep Link : $link  longitude : $longitude latitude : $latitude'),
          ),
        ],
      ),
    );
  }
}