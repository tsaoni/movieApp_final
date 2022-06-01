import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_movie_favorite_status.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieRepository mockMovieRepository;
  late GetMovieFavoriteStatus usecase;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieFavoriteStatus(
      movieRepository: mockMovieRepository,
    );
  });

  test(
    'should get movie favorite status from repository',
    () async {
      // arrange
      when(mockMovieRepository.isAddedToFavorite(1))
          .thenAnswer((_) async => true);

      // act
      final result = await usecase.execute(1);

      // assert
      expect(result, equals(true));
    },
  );
}
