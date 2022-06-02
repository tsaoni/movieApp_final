import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';

import '../../helpers/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvDatabaseHelper mockDatabaseHelper;
  late TvLocalDataSourceImpl dataSource;

  setUp(() {
    mockDatabaseHelper = MockTvDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save favorite', () {
    test(
      'should return success message when data has been inserted to database',
      () async {
        // arrange
        when(mockDatabaseHelper.insertTvFavorite(testTvTable))
            .thenAnswer((_) async => 1);

        // act
        final result = await dataSource.insertFavorite(testTvTable);

        // assert
        expect(result, equals('Added to favorite'));
      },
    );

    test(
      'should throw database exception when insert to database is failed',
      () async {
        // arrange
        when(mockDatabaseHelper.insertTvFavorite(testTvTable))
            .thenThrow(Exception());

        // act
        final call = dataSource.insertFavorite(testTvTable);

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
        when(mockDatabaseHelper.removeTvFavorite(testTvTable))
            .thenAnswer((_) async => 1);

        // act
        final result = await dataSource.removeFavorite(testTvTable);

        // assert
        expect(result, equals('Removed from favorite'));
      },
    );

    test(
      'should throw database exception when remove from database is failed',
      () async {
        // arrange
        when(mockDatabaseHelper.removeTvFavorite(testTvTable))
            .thenThrow(Exception());

        // act
        final call = dataSource.removeFavorite(testTvTable);

        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('get favorite tvs', () {
    test(
      'should return list of tv table from database',
      () async {
        // arrange
        when(mockDatabaseHelper.getFavoriteTvs())
            .thenAnswer((_) async => [testTvMap]);

        // act
        final result = await dataSource.getFavoriteTvs();

        // assert
        expect(result, equals([testTvTable]));
      },
    );
  });

  group('get tv detail by id', () {
    const tId = 1;

    test(
      'should return tv detail table when data is found',
      () async {
        // arrange
        when(mockDatabaseHelper.getTvById(tId))
            .thenAnswer((_) async => testTvMap);

        // act
        final result = await dataSource.getTvById(tId);

        // assert
        expect(result, equals(testTvTable));
      },
    );

    test(
      'should return null when data is not found',
      () async {
        // arrange
        when(mockDatabaseHelper.getTvById(tId)).thenAnswer((_) async => null);

        // act
        final result = await dataSource.getTvById(tId);

        // assert
        expect(result, equals(null));
      },
    );
  });
}
