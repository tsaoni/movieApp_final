import 'package:core/utils/exception.dart';

import '../models/tv_table.dart';
import 'db/tv_database_helper.dart';

abstract class TvLocalDataSource {
  Future<String> insertFavorite(TvTable tv);
  Future<String> removeFavorite(TvTable tv);
  Future<TvTable?> getTvById(int id);
  Future<List<TvTable>> getFavoriteTvs();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final TvDatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertFavorite(TvTable tv) async {
    try {
      await databaseHelper.insertTvFavorite(tv);
      return 'Added to favorite';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeFavorite(TvTable tv) async {
    try {
      await databaseHelper.removeTvFavorite(tv);
      return 'Removed from favorite';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final result = await databaseHelper.getTvById(id);
    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getFavoriteTvs() async {
    final result = await databaseHelper.getFavoriteTvs();
    return result.map((data) => TvTable.fromMap(data)).toList();
  }
}
