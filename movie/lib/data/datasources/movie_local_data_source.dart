import 'package:core/utils/exception.dart';

import '../models/movie_table.dart';
import 'db/movie_database_helper.dart';

abstract class MovieLocalDataSource {
  Future<String> insertFavorite(MovieTable movie);
  Future<String> removeFavorite(MovieTable movie);
  Future<MovieTable?> getMovieById(int id);
  Future<List<MovieTable>> getFavoriteMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final MovieDatabaseHelper databaseHelper;

  MovieLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertFavorite(MovieTable movie) async {
    try {
      await databaseHelper.insertMovieFavorite(movie);
      return 'Added to favorite';
    } catch (e) {
      print("fail_local_data_source");
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeFavorite(MovieTable movie) async {
    try {
      await databaseHelper.removeMovieFavorite(movie);
      return 'Removed from favorite';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<MovieTable?> getMovieById(int id) async {
    final result = await databaseHelper.getMovieById(id);
    if (result != null) {
      return MovieTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<MovieTable>> getFavoriteMovies() async {
    final result = await databaseHelper.getFavoriteMovies();
    return result.map((data) => MovieTable.fromMap(data)).toList();
  }
}
