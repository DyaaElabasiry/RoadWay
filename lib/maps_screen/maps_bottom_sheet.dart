import 'package:cool_seat/location_focus.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../current_destination_location_helper.dart';
import '../weather_screen/weather_screen.dart';
import '../weather_screen/weather_screen_data.dart';

class MapsBottomSheet extends StatelessWidget{
  final double bottomWidgetHeight;
  final Size screenSize ;

  const MapsBottomSheet({super.key, required this.bottomWidgetHeight, required this.screenSize});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationFocus(),
      child: Consumer<LocationFocus>(
        builder: (context, locationFocus, child) {
          return Container(
            height: bottomWidgetHeight,
            width: screenSize.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, -3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                // notch
                Container(
                  margin: EdgeInsets.all(10),
                  width: 20,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 10, 30, 15),
                      padding: EdgeInsets.fromLTRB(60, 10, 20, 10),
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: InkWell(
                                onTap: () {
                                  locationFocus.setLocationFocusType(LocationFocusType.current);
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.redAccent.withOpacity(
                                            locationFocus
                                                .locationFocusType ==
                                                LocationFocusType.current
                                                ? 1
                                                : 0),
                                        width: 2),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.redAccent,
                                      ),
                                      Expanded(child: SizedBox()),
                                      Center(
                                          child: Text(
                                            'Current Location',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Expanded(child: SizedBox()),
                                    ],
                                  ),
                                )),
                          ),
                          Expanded(
                            child: InkWell(
                                onTap: () {
                                  locationFocus.setLocationFocusType(LocationFocusType.destination);
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.blueAccent.withOpacity(
                                            locationFocus
                                                .locationFocusType ==
                                                LocationFocusType.destination
                                                ? 1
                                                : 0),
                                        width: 2),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.blueAccent,
                                      ),
                                      Expanded(child: SizedBox()),
                                      Center(
                                          child: Text(
                                            'Destination Location',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Expanded(child: SizedBox()),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 55,
                      top: 50,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 59,
                      top: 55,
                      child: Container(
                        width: 3,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 53,
                      top: 130,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 4),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: InkWell(
                      onTap: () {
                        goToWeatherScreen(context);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                        padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black,
                        ),
                        child: Center(
                            child: Text(
                              'Next',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      )),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

void goToWeatherScreen(context)async{
  LocationController locationController = LocationController();
  if (locationController.currentLocation == null ||
      locationController.destinationLocation == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          'Please select current and destination locations.'),
    ));
  } else {
    LatLng currentLocation = locationController.currentLocation as LatLng;
    LatLng destinationLocation = locationController.destinationLocation as LatLng;
    await WeatherScreenData().loadWeatherData(currentLocation,destinationLocation );
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WeatherScreen()));
  }
}