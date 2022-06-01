import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/remove_favorite_tv.dart';

import '../../helpers/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late RemoveFavoriteTv usecase;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = RemoveFavoriteTv(
      tvRepository: mockTvRepository,
    );
  });

  test(
    'should remove a tv from repository',
    () async {
      // arrange
      when(mockTvRepository.removeFavorite(testTvDetail))
          .thenAnswer((_) async => const Right('Removed from favorite'));

      // act
      final result = await usecase.execute(testTvDetail);

      // assert
      verify(mockTvRepository.removeFavorite(testTvDetail));
      expect(result, equals(const Right('Removed from favorite')));
    },
  );
}
