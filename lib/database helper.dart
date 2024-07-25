import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Database? database;
  Future init()async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'savedlocations.db');
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE savedlocations (id INTEGER PRIMARY KEY, name TEXT, latitude REAL, longitude REAL)');
        });
    this.database = database;
  }

  void insert(SavedLocation savedLocation) async {
    await database?.transaction((txn) async {
      txn.rawInsert('INSERT INTO savedlocations(name, latitude, longitude) VALUES("${savedLocation.name}", ${savedLocation.latitude}, ${savedLocation.longitude})');
    });
    print('saved a location');
  }

  void delete(SavedLocation savedLocation)async{
    await database?.transaction((txn)async{
      txn.rawDelete('DELETE FROM savedlocations WHERE name = "${savedLocation.name}"');
    });
  }

  Future<List<SavedLocation>>? getAllSavedLocations()async{
    print('hello1');
    List<Map<String, dynamic>>? list = await database!.rawQuery('SELECT * FROM savedlocations');
    List<SavedLocation> savedLocations = [];
    print('hello2');
    print(list);
    for (Map<String, dynamic> map in list){
      savedLocations.add(SavedLocation.fromMap(map));
    }
    //will return an empty list if no locations are saved
    return savedLocations;
  }
  
}













class SavedLocation{
  String name;
  double latitude;
  double longitude;
  SavedLocation({required this.name, required this.latitude, required this.longitude});

    static SavedLocation fromMap(Map<String, dynamic> map){

    return SavedLocation(name:  map['name'], latitude: map['latitude'], longitude: map['longitude']);

  }
}

