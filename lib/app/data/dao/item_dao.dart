import 'package:sqflite/sqflite.dart';

import '../database/db_helper.dart';
import '../model/item.dart';

class ItemDao {
  ItemDao({DbHelper? dbHelper}) : _dbHelper = dbHelper ?? DbHelper.instance;

  final DbHelper _dbHelper;

  Future<List<Item>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DbHelper.itemsTable,
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(Item.fromMap).toList();
  }

  Future<int> insert(Item item) async {
    final db = await _dbHelper.database;
    return db.insert(
      DbHelper.itemsTable,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> update(Item item) async {
    final id = item.id;
    if (id == null) throw ArgumentError('An item ID is required to update.');
    final db = await _dbHelper.database;
    return db.update(
      DbHelper.itemsTable,
      item.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return db.delete(DbHelper.itemsTable, where: 'id = ?', whereArgs: [id]);
  }
}
