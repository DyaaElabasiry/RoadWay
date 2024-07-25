import 'package:cool_seat/current_destination_location_helper.dart';
import 'package:cool_seat/database%20helper.dart';
import 'package:cool_seat/location_focus.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

void showSaveLocationAlertDialog(BuildContext context) {
  showDialog(
    context: context,

    builder: (BuildContext context) {
      String name = '';
      TextEditingController nameController = TextEditingController();
      bool locationNotSelected = LocationController().currentLocation == null &&
          LocationController().destinationLocation == null;
      LocationFocus().locationFocusType =
          LocationController().currentLocation != null ? LocationFocusType.current : LocationFocusType.destination;
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Save Location'),
        content: locationNotSelected
            ? Text('please set any location to save')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    // height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(245, 245, 245, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter a name for this location',
                        border: InputBorder.none
                      ),
                      onTap: () {
                        name = nameController.text;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  LocationSelection(),
                ],
              ),
        actions: [
          ElevatedButton(

            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          locationNotSelected
              ? SizedBox()
              : ElevatedButton(
                  onPressed: () {
                    LatLng location = LocationFocus().locationFocusType == LocationFocusType.current
                        ? LocationController().currentLocation!
                        : LocationController().destinationLocation!;
                    SavedLocation savedLocation = SavedLocation(
                        name: nameController.text,
                        latitude: location!.latitude,
                        longitude: location!.longitude);
                    DatabaseHelper().insert(savedLocation);
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
        ],
      );
    },
  );
}

class LocationSelection extends StatefulWidget {
  const LocationSelection({Key? key}) : super(key: key);

  @override
  State<LocationSelection> createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  LocationFocus locationFocus = LocationFocus();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LocationController().currentLocation == null
              ? SizedBox()
              : InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    locationFocus.locationFocusType = LocationFocusType.current;
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
                              locationFocus.locationFocusType == LocationFocusType.current ? 1 : 0),
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
          LocationController().destinationLocation == null
              ? SizedBox()
              : InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    locationFocus.locationFocusType = LocationFocusType.destination;
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
                              locationFocus.locationFocusType == LocationFocusType.destination ? 1 : 0),
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
        ],
      ),
    );
  }
}
