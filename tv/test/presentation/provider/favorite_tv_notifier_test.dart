import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_favorite_tvs.dart';
import 'package:tv/presentation/provider/favorite_tv_provider.dart';

import '../../helpers/dummy_objects.dart';
import 'favorite_tv_notifier_test.mocks.dart';

@GenerateMocks([GetFavoriteTvs])
void main() {
  late int listenerCallCount;
  late MockGetFavoriteTvs mockGetFavoriteTvs;
  late FavoriteTvNotifier provider;

  setUp(() {
    listenerCallCount = 0;
    mockGetFavoriteTvs = MockGetFavoriteTvs();
    provider = FavoriteTvNotifier(
      getFavoriteTvs: mockGetFavoriteTvs,
    )..addListener(() {
        listenerCallCount++;
      });
  });

  test(
    'should change tvs when data is gotten successfully',
    () async {
      // arrange
      when(mockGetFavoriteTvs.execute())
          .thenAnswer((_) async => Right([testFavoriteTv]));

      // act
      await provider.fetchFavoriteTvs();

      // assert
      expect(provider.favoriteState, equals(RequestState.loaded));
      expect(provider.favoriteTvs, equals([testFavoriteTv]));
      expect(listenerCallCount, equals(2));
    },
  );

  test(
    'should return database failure when error occurred',
    () async {
      // arrange
      when(mockGetFavoriteTvs.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure('Can\'t get data')));

      // act
      await provider.fetchFavoriteTvs();

      // assert
      expect(provider.favoriteState, equals(RequestState.error));
      expect(provider.message, equals('Can\'t get data'));
      expect(listenerCallCount, equals(2));
    },
  );
}
