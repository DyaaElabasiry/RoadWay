import 'package:cool_seat/current_destination_location_helper.dart';
import 'package:cool_seat/location_service.dart';
import 'package:cool_seat/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:latlong2/latlong.dart';

class OSMScreen extends StatefulWidget {
  const OSMScreen({Key? key}) : super(key: key);

  @override
  State<OSMScreen> createState() => _OSMScreenState();
}

class _OSMScreenState extends State<OSMScreen> {
  LocationController locationController = LocationController();
  LocationService locationService = LocationService();
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to white
      statusBarIconBrightness: Brightness.dark, // Set status bar icons to dark
    ));
    Size screenSize = MediaQuery.of(context).size;
    double bottomWidgetHeight = 300;
    return Scaffold(
        body: SizedBox(
      height: double.maxFinite,
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                height: screenSize.height - bottomWidgetHeight + 20,
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    backgroundColor: Colors.white,
                    initialCenter: LatLng(31.190211, 29.916429),
                    onTap: (_, latlng) {
                      print(latlng);
                      if (locationController.locationFocus == 0) {
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
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.my_location_sharp,
                          color: Colors.black,
                          size: 30,
                        )),
                  )),
              Positioned(
                  bottom: 100,
                  right: 10,
                  child: CustomPopup(
                    content: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 350,
                      ),
                      child: SingleChildScrollView(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(250, 81, 65, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.delete_outline,color: Colors.white,),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(7),
                                  margin: EdgeInsets.all(7),
                                  decoration: BoxDecoration(

                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Home',
                                    style: TextStyle(fontSize: 22),
                                  )),

                            ],
                          ),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.delete,color: Colors.red,),
                              ),
                              Container(
                                  padding: EdgeInsets.all(7),
                                  margin: EdgeInsets.all(7),
                                  decoration: BoxDecoration(

                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Work',
                                    style: TextStyle(fontSize: 22),
                                  )),
                            ],
                          ),

                        ]),
                      ),
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.bookmarks_outlined,
                          color: Colors.black,
                          size: 30,
                        )),
                  )),
              Positioned(
                  bottom: 170,
                  right: 10,
                  child: InkWell(
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.bookmark_add_outlined,
                          color: Colors.black,
                          size: 30,
                        )),
                  ))
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
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
                                    locationController.locationFocus = 0;
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.redAccent.withOpacity(
                                              locationController
                                                          .locationFocus ==
                                                      0
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
                                    locationController.locationFocus = 1;
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.blueAccent.withOpacity(
                                              locationController
                                                          .locationFocus ==
                                                      0
                                                  ? 0
                                                  : 1),
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
                          if (locationController.currentLocation == null &&
                              locationController.destinationLocation == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Please select current and destination locations.'),
                            ));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => WeatherScreen()));
                          }
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
            ),
          )
        ],
      ),
    ));
  }
}
