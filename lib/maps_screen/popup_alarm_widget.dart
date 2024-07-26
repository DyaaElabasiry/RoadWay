import 'package:RoadWay/location/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:wheel_picker/wheel_picker.dart';

import '../location/current_destination_location_helper.dart';

class PopupAlarm extends StatefulWidget {
  const PopupAlarm({super.key});

  @override
  State<PopupAlarm> createState() => _PopupAlarmState();
}

class _PopupAlarmState extends State<PopupAlarm> {
  final minutesWheel = WheelPickerController(itemCount: 60, initialIndex: 5);
  var textStyle = const TextStyle(fontSize: 35.0, height: 1.5);

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
                  const Text('An alarm is already running'),
                  ElevatedButton(
                    onPressed: () async {
                      FlutterBackgroundService().invoke('stopService');
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text('Stop Alarm'),
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
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: WheelPicker(
                      controller: minutesWheel,
                      builder: (context, index) {
                        return Text(
                          index.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
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
                    padding: const EdgeInsets.only(left: 20),
                    width: 250,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Select the number of minutes for the alarm to fire before reaching your destination',
                          style: TextStyle(fontSize: 17),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            ElevatedButton(
                                onPressed: () async {
                                  if(LocationController().destinationLocation==null){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a destination')));
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
                                child: const Text('Save'))
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
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      ),
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: const Icon(
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