import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/save_favorite_tv.dart';

import '../../helpers/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late SaveFavoriteTv usecase;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveFavoriteTv(
      tvRepository: mockTvRepository,
    );
  });

  test(
    'should save a tv to the repository',
    () async {
      // arrange
      when(mockTvRepository.saveFavorite(testTvDetail))
          .thenAnswer((_) async => const Right('Added to favorite'));

      // act
      final result = await usecase.execute(testTvDetail);

      // assert
      verify(mockTvRepository.saveFavorite(testTvDetail));
      expect(result, equals(const Right('Added to favorite')));
    },
  );
}
