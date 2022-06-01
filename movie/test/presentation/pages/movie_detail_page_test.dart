import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:provider/provider.dart';

import '../../helpers/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailNotifier])
void main() {
  late MockMovieDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'favorite button should display add icon when movie not added to favorite',
    (WidgetTester tester) async {
      // arrange
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationsState).thenReturn(RequestState.loaded);
      when(mockNotifier.recommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToFavorite).thenReturn(false);

      // act
      final favoriteButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(
        _makeTestableWidget(const MovieDetailPage(id: 1)),
        const Duration(milliseconds: 500),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // assert
      expect(favoriteButtonIcon, equals(findsOneWidget));
    },
  );

  testWidgets(
    'favorite button should dispay check icon when movie is added to wathclist',
    (WidgetTester tester) async {
      // arrange
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationsState).thenReturn(RequestState.loaded);
      when(mockNotifier.recommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToFavorite).thenReturn(true);

      // act
      final favoriteButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(
        _makeTestableWidget(const MovieDetailPage(id: 1)),
        const Duration(milliseconds: 500),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // assert
      expect(favoriteButtonIcon, equals(findsOneWidget));
    },
  );

  testWidgets(
    'favorite button should display snackbar when added to favorite',
    (WidgetTester tester) async {
      // arrange
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationsState).thenReturn(RequestState.loaded);
      when(mockNotifier.recommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToFavorite).thenReturn(false);
      when(mockNotifier.favoriteMessage).thenReturn('Added to favorite');

      // act
      final favoriteButton = find.byType(ElevatedButton);

      await tester.pumpWidget(
        _makeTestableWidget(const MovieDetailPage(id: 1)),
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
      when(mockNotifier.movieState).thenReturn(RequestState.loaded);
      when(mockNotifier.movie).thenReturn(testMovieDetail);
      when(mockNotifier.recommendationsState).thenReturn(RequestState.loaded);
      when(mockNotifier.recommendations).thenReturn(<Movie>[]);
      when(mockNotifier.isAddedToFavorite).thenReturn(false);
      when(mockNotifier.favoriteMessage).thenReturn('Failed');

      // act
      final favoriteButton = find.byType(ElevatedButton);

      await tester.pumpWidget(
        _makeTestableWidget(const MovieDetailPage(id: 1)),
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
