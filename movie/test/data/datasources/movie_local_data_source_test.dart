import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';

import '../../helpers/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieDatabaseHelper mockDatabaseHelper;
  late MovieLocalDataSourceImpl dataSource;

  setUp(() {
    mockDatabaseHelper = MockMovieDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save favorite', () {
    test(
      'should return success message when data has been inserted to database',
      () async {
        // arrange
        when(mockDatabaseHelper.insertMovieFavorite(testMovieTable))
            .thenAnswer((_) async => 1);

        // act
        final result = await dataSource.insertFavorite(testMovieTable);

        // assert
        expect(result, equals('Added to favorite'));
      },
    );

    test(
      'should throw database exception when insert to database is failed',
      () async {
        // arrange
        when(mockDatabaseHelper.insertMovieFavorite(testMovieTable))
            .thenThrow(Exception());

        // act
        final call = dataSource.insertFavorite(testMovieTable);

        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('remove favorite', () {
    test(
      'should return success message when data has been removed from database',
      () async {
        // arrange
        when(mockDatabaseHelper.removeMovieFavorite(testMovieTable))
            .thenAnswer((_) async => 1);

        // act
        final result = await dataSource.removeFavorite(testMovieTable);

        // assert
        expect(result, equals('Removed from favorite'));
      },
    );

    test(
      'should throw database exception when remove from database is failed',
      () async {
        // arrange
        when(mockDatabaseHelper.removeMovieFavorite(testMovieTable))
            .thenThrow(Exception());

        // act
        final call = dataSource.removeFavorite(testMovieTable);

        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('get favorite movies', () {
    test(
      'should return list of movie table from database',
      () async {
        // arrange
        when(mockDatabaseHelper.getFavoriteMovies())
            .thenAnswer((_) async => [testMovieMap]);

        // act
        final result = await dataSource.getFavoriteMovies();

        // assert
        expect(result, equals([testMovieTable]));
      },
    );
  });

  group('get movie detail by id', () {
    const tId = 1;

    test(
      'should return movie detail table when data is found',
      () async {
        // arrange
        when(mockDatabaseHelper.getMovieById(tId))
            .thenAnswer((_) async => testMovieMap);

        // act
        final result = await dataSource.getMovieById(tId);

        // assert
        expect(result, equals(testMovieTable));
      },
    );

    test(
      'should return null when data is not found',
      () async {
        // arrange
        when(mockDatabaseHelper.getMovieById(tId))
            .thenAnswer((_) async => null);

        // act
        final result = await dataSource.getMovieById(tId);

        // assert
        expect(result, equals(null));
      },
    );
  });
}
