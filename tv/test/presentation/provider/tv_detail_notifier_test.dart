import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_tv_favorite_status.dart';
import 'package:tv/domain/usecases/remove_favorite_tv.dart';
import 'package:tv/domain/usecases/save_favorite_tv.dart';
import 'package:tv/presentation/provider/tv_detail_notifier.dart';

import '../../helpers/dummy_objects.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetTvFavoriteStatus,
  SaveFavoriteTv,
  RemoveFavoriteTv,
])
void main() {
  late int listenerCallCount;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetTvFavoriteStatus mockGetFavoriteStatus;
  late MockSaveFavoriteTv mockSaveFavorite;
  late MockRemoveFavoriteTv mockRemoveFavorite;
  late TvDetailNotifier provider;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetFavoriteStatus = MockGetTvFavoriteStatus();
    mockSaveFavorite = MockSaveFavoriteTv();
    mockRemoveFavorite = MockRemoveFavoriteTv();
    provider = TvDetailNotifier(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getFavoriteStatus: mockGetFavoriteStatus,
      saveFavorite: mockSaveFavorite,
      removeFavorite: mockRemoveFavorite,
    )..addListener(() {
        listenerCallCount++;
      });
  });

  const tId = 1;

  final tTv = Tv(
    backdropPath: '/path.jpg',
    firstAirDate: '2022-01-01',
    genreIds: const [1, 2, 3, 4],
    id: 1,
    name: 'Name',
    overview: 'Overview',
    posterPath: '/path.jpg',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvs = <Tv>[tTv];

  void _arrangeUsecase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => const Right(testTvDetail));
    when(mockGetTvRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTvs));
  }

  group('tv detail', () {
    test(
      'should get tv detail data from the usecase',
      () async {
        // arrange
        _arrangeUsecase();

        // act
        await provider.fetchTvDetail(tId);

        // assert
        verify(mockGetTvDetail.execute(tId));
      },
    );

    test(
      'should change state to loading when usecase is called',
      () {
        // arrange
        _arrangeUsecase();

        // act
        provider.fetchTvDetail(tId);

        // assert
        expect(provider.tvState, equals(RequestState.loading));
        expect(listenerCallCount, equals(1));
      },
    );

    test(
      'should change tv data is gotten successfully',
      () async {
        // arrange
        _arrangeUsecase();

        // act
        await provider.fetchTvDetail(tId);

        // assert
        expect(provider.tvState, equals(RequestState.loaded));
        expect(provider.tv, equals(testTvDetail));
        expect(listenerCallCount, equals(3));
      },
    );

    test(
      'should change recommendation tvs when data is gotten successfully',
      () async {
        // arrange
        _arrangeUsecase();

        // act
        await provider.fetchTvDetail(tId);

        // assert
        expect(provider.tvState, equals(RequestState.loaded));
        expect(provider.recommendations, equals(tTvs));
      },
    );

    test(
      'should return server failure when error',
      () async {
        // arrange
        when(mockGetTvDetail.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server failure')));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvs));

        // act
        await provider.fetchTvDetail(tId);

        // assert
        expect(provider.tvState, equals(RequestState.error));
        expect(provider.message, equals('Server failure'));
        expect(listenerCallCount, equals(2));
      },
    );
  });

  group('get tv recommendations', () {
    test(
      'should get tv recommendations data from the usecase',
      () async {
        // arrange
        _arrangeUsecase();

        // act
        await provider.fetchTvDetail(tId);

        // assert
        verify(mockGetTvRecommendations.execute(tId));
        expect(provider.recommendations, equals(tTvs));
      },
    );

    test(
      'should change recommendations state when data is gotten successfully',
      () async {
        // arrange
        _arrangeUsecase();

        // act
        await provider.fetchTvDetail(tId);

        // assert
        expect(provider.recommendationsState, equals(RequestState.loaded));
        expect(provider.recommendations, equals(tTvs));
      },
    );

    test(
      'should change error message when the request is unsuccessful',
      () async {
        // arrange
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Failed')));

        // act
        await provider.fetchTvDetail(tId);

        // assert
        expect(provider.recommendationsState, equals(RequestState.error));
        expect(provider.message, equals('Failed'));
      },
    );
  });

  group('tv favorite', () {
    test(
      'should get the favorite status',
      () async {
        // arrange
        when(mockGetFavoriteStatus.execute(1)).thenAnswer((_) async => true);

        // act
        await provider.loadFavoriteStatus(1);

        // assert
        expect(provider.isAddedToFavorite, equals(true));
      },
    );

    test(
      'should execute save favorite when function called',
      () async {
        // arrange
        when(mockSaveFavorite.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Success'));
        when(mockGetFavoriteStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);

        // act
        await provider.addToFavorite(testTvDetail);

        // assert
        verify(mockSaveFavorite.execute(testTvDetail));
      },
    );

    test(
      'should execute remove favorite when function called',
      () async {
        // arrange
        when(mockRemoveFavorite.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Removed'));
        when(mockGetFavoriteStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);

        // act
        await provider.removeFromFavorite(testTvDetail);

        // assert
        verify(mockRemoveFavorite.execute(testTvDetail));
      },
    );

    test(
      'should change favorite status when adding favorite success',
      () async {
        // arrange
        when(mockSaveFavorite.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Added to favorite'));
        when(mockGetFavoriteStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);

        // act
        await provider.addToFavorite(testTvDetail);

        // assert
        verify(mockGetFavoriteStatus.execute(testTvDetail.id));
        expect(provider.isAddedToFavorite, equals(true));
        expect(provider.favoriteMessage, equals('Added to favorite'));
        expect(listenerCallCount, equals(1));
      },
    );

    test(
      'should change favorite message when adding favorite failed',
      () async {
        // arrange
        when(mockSaveFavorite.execute(testTvDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetFavoriteStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);

        // act
        await provider.addToFavorite(testTvDetail);

        // assert
        expect(provider.favoriteMessage, equals('Failed'));
        expect(listenerCallCount, equals(1));
      },
    );
  });
}
