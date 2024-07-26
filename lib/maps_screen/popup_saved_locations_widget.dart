import 'package:RoadWay/location/location_focus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:latlong2/latlong.dart';

import '../location/current_destination_location_helper.dart';
import '../database/database helper.dart';

class PopupSavedLocations extends StatefulWidget {
  const PopupSavedLocations({super.key, required this.mapController});
  final MapController mapController ;
  @override
  State<PopupSavedLocations> createState() => _PopupSavedLocationsState();
}

class _PopupSavedLocationsState extends State<PopupSavedLocations> {
  @override
  Widget build(BuildContext context) {
    return CustomPopup(
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
      content: FutureBuilder<List<SavedLocation>?>(
          future: DatabaseHelper().getAllSavedLocations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data!.isEmpty) {
              return const SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(child: Text('No saved locations')));
            }

            List<SavedLocation> savedLocations = snapshot.data!;

            return ConstrainedBox(
              constraints: const BoxConstraints(
                  maxHeight: 350, minWidth: 250, maxWidth: 250),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: savedLocations.map((location) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            widget.mapController.move(
                                LatLng(location.latitude, location.longitude),
                                12);
                            if (LocationFocus().locationFocusType == LocationFocusType.current) {
                              LocationController().setCurrentLocation(
                                  LatLng(location.latitude,
                                      location.longitude));
                            } else {
                              LocationController().setDestinationLocation(
                                  LatLng(location.latitude,
                                      location.longitude));
                            }
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  DatabaseHelper().delete(location);
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(250, 81, 65, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(7),
                                  margin: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    location.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 22),
                                  )),
                            ],
                          ),
                        ),
                      );
                    }).toList()),
              ),
            );
          }),
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
            Icons.bookmarks_outlined,
            color: Colors.black,
            size: 30,
          )),
    );
  }
}
