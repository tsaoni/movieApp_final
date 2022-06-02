import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_season_episode.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/provider/tv_detail_notifier.dart';
import 'package:tv/presentation/provider/tv_season_episodes_notifier.dart';

import '../../helpers/dummy_objects.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailNotifier, TvSeasonEpisodesNotifier])
void main() {
  late MockTvDetailNotifier mockNotifier;
  late MockTvSeasonEpisodesNotifier mockTvSeasonEpisodesNotifier;

  setUp(() {
    mockNotifier = MockTvDetailNotifier();
    mockTvSeasonEpisodesNotifier = MockTvSeasonEpisodesNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvDetailNotifier>.value(
      value: mockNotifier,
      child: ChangeNotifierProvider<TvSeasonEpisodesNotifier>.value(
        value: mockTvSeasonEpisodesNotifier,
        child: MaterialApp(
          home: body,
        ),
      ),
    );
  }

  testWidgets(
    'favorite button should display add icon when tv not added to favorite',
    (WidgetTester tester) async {
      // arrange
      when(mockNotifier.tvState).thenReturn(RequestState.loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.recommendationsState).thenReturn(RequestState.loaded);
      when(mockNotifier.recommendations).thenReturn(<Tv>[]);
      when(mockTvSeasonEpisodesNotifier.seasonEpisodesState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeasonEpisodesNotifier.seasonEpisodes)
          .thenReturn(<TvSeasonEpisode>[]);
      when(mockNotifier.isAddedToFavorite).thenReturn(false);

      // act
      final favoriteButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(
        _makeTestableWidget(const TvDetailPage(id: 1)),
        const Duration(milliseconds: 500),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // assert
      expect(favoriteButtonIcon, equals(findsOneWidget));
    },
  );

  testWidgets(
    'favorite button should display check icon when tv is added to favorite',
    (WidgetTester tester) async {
      // arrange
      when(mockNotifier.tvState).thenReturn(RequestState.loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.recommendationsState).thenReturn(RequestState.loaded);
      when(mockNotifier.recommendations).thenReturn(<Tv>[]);
      when(mockTvSeasonEpisodesNotifier.seasonEpisodesState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeasonEpisodesNotifier.seasonEpisodes)
          .thenReturn(<TvSeasonEpisode>[]);
      when(mockNotifier.isAddedToFavorite).thenReturn(true);

      // act
      final favoriteButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(
        _makeTestableWidget(const TvDetailPage(id: 1)),
        const Duration(milliseconds: 500),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // assert
      expect(favoriteButtonIcon, equals(findsOneWidget));
    },
  );

  testWidgets(
    'favorite button should display snackbar when tv is added to favorite',
    (WidgetTester tester) async {
      // arrange
      when(mockNotifier.tvState).thenReturn(RequestState.loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.recommendationsState).thenReturn(RequestState.loaded);
      when(mockNotifier.recommendations).thenReturn(<Tv>[]);
      when(mockTvSeasonEpisodesNotifier.seasonEpisodesState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeasonEpisodesNotifier.seasonEpisodes)
          .thenReturn(<TvSeasonEpisode>[]);
      when(mockNotifier.isAddedToFavorite).thenReturn(false);
      when(mockNotifier.favoriteMessage).thenReturn('Added to favorite');

      // act
      final favoriteButton = find.byType(ElevatedButton);

      await tester.pumpWidget(
        _makeTestableWidget(const TvDetailPage(id: 1)),
        const Duration(milliseconds: 500),
      );

      // assert
      expect(find.byIcon(Icons.add), equals(findsOneWidget));

      // act
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      await tester.tap(favoriteButton);
      await tester.pump();

      // assert
      expect(find.byType(SnackBar), equals(findsOneWidget));
      expect(find.text('Added to favorite'), equals(findsOneWidget));
    },
  );

  testWidgets(
    'favorite button should display alert dialog when add to favorite failed',
    (WidgetTester tester) async {
      // arrange
      when(mockNotifier.tvState).thenReturn(RequestState.loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.recommendationsState).thenReturn(RequestState.loaded);
      when(mockNotifier.recommendations).thenReturn(<Tv>[]);
      when(mockTvSeasonEpisodesNotifier.seasonEpisodesState)
          .thenReturn(RequestState.loaded);
      when(mockTvSeasonEpisodesNotifier.seasonEpisodes)
          .thenReturn(<TvSeasonEpisode>[]);
      when(mockNotifier.isAddedToFavorite).thenReturn(false);
      when(mockNotifier.favoriteMessage).thenReturn('Failed');

      // act
      final favoriteButton = find.byType(ElevatedButton);

      await tester.pumpWidget(
        _makeTestableWidget(const TvDetailPage(id: 1)),
        const Duration(milliseconds: 500),
      );

      // assert
      expect(find.byIcon(Icons.add), equals(findsOneWidget));

      // act
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      await tester.tap(favoriteButton);
      await tester.pump();

      // assert
      expect(find.byType(AlertDialog), equals(findsOneWidget));
      expect(find.text('Failed'), equals(findsOneWidget));
    },
  );
}
