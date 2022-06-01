import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_favorite_status.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late GetTvFavoriteStatus usecase;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvFavoriteStatus(
      tvRepository: mockTvRepository,
    );
  });

  test(
    'should get tv favorite status from repository',
    () async {
      // arrange
      when(mockTvRepository.isAddedToFavorite(1))
          .thenAnswer((_) async => true);

      // act
      final result = await usecase.execute(1);

      // assert
      expect(result, equals(true));
    },
  );
}
