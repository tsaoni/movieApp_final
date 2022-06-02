import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_favorite_movies.dart';

class FavoriteMovieNotifier extends ChangeNotifier {
  var _favoriteMovies = <Movie>[];
  List<Movie> get favoriteMovies => _favoriteMovies;

  var _favoriteState = RequestState.empty;
  RequestState get favoriteState => _favoriteState;

  String _message = '';
  String get message => _message;

  FavoriteMovieNotifier({required this.getFavoriteMovies});

  final GetFavoriteMovies getFavoriteMovies;

  Future<void> fetchFavoriteMovies() async {
    _favoriteState = RequestState.loading;
    notifyListeners();

    final result = await getFavoriteMovies.execute();
    result.fold(
      (failure) {
        _favoriteState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _favoriteState = RequestState.loaded;
        _favoriteMovies = moviesData;
        notifyListeners();
      },
    );
  }
}
