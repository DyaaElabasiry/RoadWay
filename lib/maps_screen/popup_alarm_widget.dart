import 'package:cool_seat/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:wheel_picker/wheel_picker.dart';

import '../current_destination_location_helper.dart';
import '../database helper.dart';

class PopupAlarm extends StatefulWidget {
  const PopupAlarm({Key? key}) : super(key: key);

  @override
  State<PopupAlarm> createState() => _PopupAlarmState();
}

class _PopupAlarmState extends State<PopupAlarm> {
  final minutesWheel = WheelPickerController(itemCount: 60, initialIndex: 5);
  var textStyle = TextStyle(fontSize: 35.0, height: 1.5);

  @override
  Widget build(BuildContext context) {
    return CustomPopup(
      content: FutureBuilder(
        future: FlutterBackgroundService().isRunning(),
        builder: (context,snapshot) {
          if(snapshot.data == true ){
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('An alarm is already running'),
                  ElevatedButton(
                    onPressed: () async {
                      FlutterBackgroundService().invoke('stopAlarm');
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Text('Stop Alarm'),
                  )
                ],
              ),
            );
          }
          if (snapshot.data == false) {
            return Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: WheelPicker(
                      controller: minutesWheel,
                      builder: (context, index) {
                        return Text(
                          index.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                        );
                      },
                      selectedIndexColor: Colors.black,
                      style: WheelPickerStyle(
                        size: 200,
                        itemExtent: textStyle.fontSize! * textStyle.height!,
                        // Text height
                        squeeze: 1.25,
                        diameterRatio: .8,
                        surroundingOpacity: .25,
                        magnification: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    width: 250,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Select the number of minutes for the alarm to fire before reaching your destination',
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel')),
                            ElevatedButton(
                                onPressed: () async {
                                  if(LocationController().destinationLocation==null){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a destination')));
                                    Navigator.pop(context);
                                  }else{
                                    try {
                                      await LocationService().determinePosition();
                                      int timeInMinutes = minutesWheel.selected;
                                      await FlutterBackgroundService().startService().then((value){
                                        fireAlarm(timeInMinutes);
                                      });
                                      setState(() {});
                                      Navigator.pop(context);
                                    } on Exception catch (e) {

                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(e.toString()),
                                      ));
                                    }
                                  }
                                },
                                child: Text('Save'))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      ),
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Icon(
            Icons.alarm,
            color: Colors.black,
            size: 30,
          )),
    );
  }
}

 void fireAlarm(int timeInMinutes)async{
   FlutterBackgroundService().invoke('fireAlarm', {
     'latitude': LocationController().destinationLocation!.latitude,
     'longitude': LocationController().destinationLocation!.longitude,
     'timeInMinutes': timeInMinutes
   });
}