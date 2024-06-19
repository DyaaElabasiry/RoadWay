import 'package:cool_seat/database%20helper.dart';
import 'package:flutter/material.dart';

class SqfliteTestWidget extends StatefulWidget {
  @override
  State<SqfliteTestWidget> createState() => _SqfliteTestWidgetState();
}

class _SqfliteTestWidgetState extends State<SqfliteTestWidget> {
  @override
  Widget build(BuildContext context) {
    SavedLocation savedLocation = SavedLocation(
      name: 'name',
      latitude: 0.0,
      longitude: 0.0,
    );
    DatabaseHelper database = DatabaseHelper();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: FutureBuilder<List<SavedLocation>>(
          future: database.getAllSavedLocations(),
          builder: (BuildContext context,
              AsyncSnapshot<List<SavedLocation>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...snapshot.data!
                      .map((SavedLocation savedLocation) => Text(
                          '${savedLocation.name} ${savedLocation.latitude} ${savedLocation.longitude}'))
                      .toList(),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          database.insert(savedLocation);
                        });
                      },
                      child: Text('Insert')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          database.delete(savedLocation);
                        });
                      },
                      child: Text('delete')),
                ],
              );
            }else{
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  TextButton(
                      onPressed: () {
                        setState(() {
                          database.insert(savedLocation);
                        });
                      },
                      child: Text('Insert')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          database.delete(savedLocation);
                        });
                      },
                      child: Text('delete')),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
