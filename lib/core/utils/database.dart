import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class Database {
  static Future<sqflite.Database> createConnection() async {
    return await sqflite.openDatabase(
      await _getDatabasePath(),
      onCreate: (sqflite.Database db, int version) async {
        //await db.execute(
        //  'CREATE TABLE users(id INTEGER PRIMARY KEY,
        // full_name TEXT, email TEXT, mobile_number TEXT)',
        //);
      },
      version: 1,
      // Fixes "attempt to re-open an already-closed object" for concurrent use.
      singleInstance: false,
    );
  }

  static Future<void> drop() async {
    await sqflite.deleteDatabase(await _getDatabasePath());
  }

  static Future<String> _getDatabasePath() async {
    return join(await sqflite.getDatabasesPath(), 'database.db');
  }
}
