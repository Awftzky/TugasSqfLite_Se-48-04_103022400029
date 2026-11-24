import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper instance = DbHelper._();
  static const _databaseName = 'supply_app.db';
  static const _databaseVersion = 1;
  static const itemsTable = 'items';

  Future<Database>? _database;

  Future<Database> get database async {
    final current = _database;
    if (current != null) return current;
    final pending = _openDatabase();
    _database = pending;
    try {
      return await pending;
    } catch (_) {
      _database = null;
      rethrow;
    }
  }

  Future<Database> _openDatabase() async {
    final directory = await getDatabasesPath();
    return openDatabase(
      p.join(directory, _databaseName),
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $itemsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            quantity REAL NOT NULL,
            unit TEXT NOT NULL,
            location TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
