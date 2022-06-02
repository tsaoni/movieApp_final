import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/save_favorite_movie.dart';

import '../../helpers/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieRepository mockMovieRepository;
  late SaveFavoriteMovie usecase;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveFavoriteMovie(
      movieRepository: mockMovieRepository,
    );
  });

  test(
    'should save a movie to the repository',
    () async {
      // arrange
      when(mockMovieRepository.saveFavorite(testMovieDetail))
          .thenAnswer((_) async => const Right('Added to favorite'));

      // act
      final result = await usecase.execute(testMovieDetail);

      // assert
      verify(mockMovieRepository.saveFavorite(testMovieDetail));
      expect(result, equals(const Right('Added to favorite')));
    },
  );
}
