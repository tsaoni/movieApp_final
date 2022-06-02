import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../models/tv_table.dart';

class TvDatabaseHelper {
  static TvDatabaseHelper? _databaseHelper;
  TvDatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory TvDatabaseHelper() => _databaseHelper ?? TvDatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tvFavoriteTable = 'tvFavoriteTable';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/tv.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tvFavoriteTable (
        firstAirDate TEXT,
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT,
        voteAverage DOUBLE
      );
    ''');
  }

  Future<int> insertTvFavorite(TvTable tv) async {
    final db = await database;
    return await db!.insert(_tvFavoriteTable, tv.toMap());
  }

  Future<int> removeTvFavorite(TvTable tv) async {
    final db = await database;
    return await db!.delete(
      _tvFavoriteTable,
      where: 'id = ?',
      whereArgs: [tv.id],
    );
  }

  Future<Map<String, dynamic>?> getTvById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tvFavoriteTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getFavoriteTvs() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db!.query(_tvFavoriteTable);

    return results;
  }
}
