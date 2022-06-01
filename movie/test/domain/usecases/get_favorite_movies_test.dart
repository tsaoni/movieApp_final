import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_favorite_movies.dart';

import '../../helpers/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieRepository mockMovieRepository;
  late GetFavoriteMovies usecase;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetFavoriteMovies(mockMovieRepository);
  });

  test(
    'should get list of movie from the repository',
    () async {
      // arrange
      when(mockMovieRepository.getFavoriteMovies())
          .thenAnswer((_) async => Right(testMovieList));

      // act
      final result = await usecase.execute();

      // assert
      expect(result, equals(Right(testMovieList)));
    },
  );
}
