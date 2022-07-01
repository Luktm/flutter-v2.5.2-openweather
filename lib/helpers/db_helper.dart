import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> database() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'city.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      return db.execute(
          'CREATE TABLE favorite_city (city TEXT, weather_icon TEXT, description TEXT, temp REAL, date INTEGER)'
      );
    });
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final Database db = await DBHelper.database();

    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  static Future<List<Map<String, Object>>> getData(String table,) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
  
}
