import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_favorite_tvs.dart';

import '../../helpers/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late GetFavoriteTvs usecase;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetFavoriteTvs(mockTvRepository);
  });

  test(
    'should get list of tv from the repository',
    () async {
      // arrange
      when(mockTvRepository.getFavoriteTvs())
          .thenAnswer((_) async => Right(testTvList));

      // act
      final result = await usecase.execute();

      // assert
      expect(result, equals(Right(testTvList)));
    },
  );
}
