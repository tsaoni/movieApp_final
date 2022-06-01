import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../models/movie_table.dart';

class MovieDatabaseHelper {
  static MovieDatabaseHelper? _databaseHelper;
  MovieDatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory MovieDatabaseHelper() =>
      _databaseHelper ?? MovieDatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _movieFavoriteTable = 'movieFavoriteTable';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/movie.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_movieFavoriteTable (
        releaseDate TEXT,
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        voteAverage DOUBLE
      );
    ''');
  }

  Future<int> insertMovieFavorite(MovieTable movie) async {
    print("fail_database_helper");
    final db = await database;
    print("fail_database_helper_after_get_database");
    print(db);
    return await db!.insert(_movieFavoriteTable, movie.toMap());
  }

  Future<int> removeMovieFavorite(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _movieFavoriteTable,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _movieFavoriteTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getFavoriteMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db!.query(_movieFavoriteTable);

    return results;
  }
}
