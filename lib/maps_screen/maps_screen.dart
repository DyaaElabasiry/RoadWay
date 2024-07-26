import 'package:RoadWay/location/current_destination_location_helper.dart';
import 'package:RoadWay/location/location_focus.dart';
import 'package:RoadWay/location/location_service.dart';
import 'package:RoadWay/maps_screen/maps_bottom_sheet.dart';
import 'package:RoadWay/maps_screen/popup_alarm_widget.dart';
import 'package:RoadWay/maps_screen/popup_saved_locations_widget.dart';
import 'package:RoadWay/maps_screen/save_location_alert_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../location/links.dart';

class OSMScreen extends StatefulWidget {
  const OSMScreen({super.key});

  @override
  State<OSMScreen> createState() => _OSMScreenState();
}

class _OSMScreenState extends State<OSMScreen> {
  // LocationController locationController = LocationController();
  LocationService locationService = LocationService();
  LocationFocus locationFocus = LocationFocus();
  MapController mapController = MapController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ReceiveSharingIntent.instance.getInitialMedia().then((value)async{
      if (value.isNotEmpty) {
        String link = value[0].path;
        LatLng? coordinates = await LinkHelper().getCoordinates(link);
        if(coordinates != null){
          mapController.move(coordinates, 10);
          LocationController().setDestinationLocation(coordinates);
        }

        // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.instance.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to white
      statusBarIconBrightness: Brightness.dark, // Set status bar icons to dark
    ));
    Size screenSize = MediaQuery.of(context).size;
    double bottomWidgetHeight = 300;
    return ChangeNotifierProvider(
      create: (context) => LocationController(),
      child: Scaffold(
          body: SizedBox(
        height: double.maxFinite,
        child: Consumer<LocationController>(
          builder: (context,locationController,child) {
            return Stack(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: screenSize.height - bottomWidgetHeight + 20,
                      child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          backgroundColor: Colors.white,
                          initialCenter: const LatLng(31.190211, 29.916429),
                          onTap: (_, latlng) {
                            if (locationFocus.locationFocusType == LocationFocusType.current) {
                              locationController.setCurrentLocation(latlng);
                            } else {
                              locationController.setDestinationLocation(latlng);
                            }
                            setState(() {});
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          MarkerLayer(
                            markers: locationController.currentDestinationMarkersList,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 30,
                        right: 10,
                        child: InkWell(
                          onTap: () async {
                            try {
                              LatLng currentLocation =
                              await locationService.determinePosition();
                              locationController.setCurrentLocation(currentLocation);

                              if (locationController.currentLocation != null) {
                                mapController.move(
                                    locationController.currentLocation!, 15);
                              }
                              setState(() {});
                            } on Exception catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(e.toString()),
                              ));
                            }
                          },
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
                                    offset:
                                    const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.my_location_sharp,
                                color: Colors.black,
                                size: 30,
                              )),
                        )),
                    Positioned(
                        bottom: 100,
                        right: 10,
                        child: PopupSavedLocations(mapController: mapController,)),
                    Positioned(
                        bottom: 170,
                        right: 10,
                        child: InkWell(
                          onTap: (){
                            showSaveLocationAlertDialog(context);
                          },
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
                                    offset:
                                    const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.bookmark_add_outlined,
                                color: Colors.black,
                                size: 30,
                              )),
                        )),
                    const Positioned(
                        bottom: 240,
                        right: 10,
                        child: PopupAlarm()),

                  ],
                ),
                Positioned(
                  bottom: 0,
                  child:MapsBottomSheet(bottomWidgetHeight: bottomWidgetHeight, screenSize: screenSize),
                )
              ],
            );
          }
        ),
      )),
    );
  }
}


