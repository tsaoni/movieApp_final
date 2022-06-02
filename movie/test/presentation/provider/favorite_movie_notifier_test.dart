import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_favorite_movies.dart';
import 'package:movie/presentation/provider/favorite_movie_notifier.dart';

import '../../helpers/dummy_objects.dart';
import 'favorite_movie_notifier_test.mocks.dart';

@GenerateMocks([GetFavoriteMovies])
void main() {
  late int listenerCallCount;
  late MockGetFavoriteMovies mockGetFavoriteMovies;
  late FavoriteMovieNotifier provider;

  setUp(() {
    listenerCallCount = 0;
    mockGetFavoriteMovies = MockGetFavoriteMovies();
    provider = FavoriteMovieNotifier(
      getFavoriteMovies: mockGetFavoriteMovies,
    )..addListener(() {
        listenerCallCount++;
      });
  });

  test(
    'should change movies when data is gotten successfully',
    () async {
      // arrange
      when(mockGetFavoriteMovies.execute())
          .thenAnswer((_) async => Right([testFavoriteMovie]));

      // act
      await provider.fetchFavoriteMovies();

      // assert
      expect(provider.favoriteState, equals(RequestState.loaded));
      expect(provider.favoriteMovies, equals([testFavoriteMovie]));
      expect(listenerCallCount, equals(2));
    },
  );

  test(
    'should return database failure when error',
    () async {
      // arrange
      when(mockGetFavoriteMovies.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure('Can\'t get data')));

      // act
      await provider.fetchFavoriteMovies();

      // assert
      expect(provider.favoriteState, equals(RequestState.error));
      expect(provider.message, equals('Can\'t get data'));
      expect(listenerCallCount, equals(2));
    },
  );
}
