import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/get_movie_recommendations.dart';
import '../../domain/usecases/get_movie_favorite_status.dart';
import '../../domain/usecases/remove_favorite_movie.dart';
import '../../domain/usecases/save_favorite_movie.dart';

class MovieDetailNotifier extends ChangeNotifier {
  static const favoriteAddSuccessMessage = 'Added to favorite';
  static const favoriteRemoveSuccessMessage = 'Removed from favorite';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetMovieFavoriteStatus getFavoriteStatus;
  final SaveFavoriteMovie saveFavorite;
  final RemoveFavoriteMovie removeFavorite;

  MovieDetailNotifier({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getFavoriteStatus,
    required this.saveFavorite,
    required this.removeFavorite,
  });

  late MovieDetail _movie;
  MovieDetail get movie => _movie;

  RequestState _movieState = RequestState.empty;
  RequestState get movieState => _movieState;

  List<Movie> _recommendations = [];
  List<Movie> get recommendations => _recommendations;

  RequestState _recommendationsState = RequestState.empty;
  RequestState get recommendationsState => _recommendationsState;

  String _message = '';
  String get message => _message;

  bool _isAddedToFavorite = false;
  bool get isAddedToFavorite => _isAddedToFavorite;

  String _favoriteMessage = '';
  String get favoriteMessage => _favoriteMessage;

  Future<void> fetchMovieDetail(int id) async {
    _movieState = RequestState.loading;
    notifyListeners();

    final detailResult = await getMovieDetail.execute(id);
    final recommendationResult = await getMovieRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _movieState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (movie) {
        _recommendationsState = RequestState.loading;
        _movie = movie;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationsState = RequestState.error;
            _message = failure.message;
          },
          (movies) {
            _recommendationsState = RequestState.loaded;
            _recommendations = movies;
          },
        );
        _movieState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  Future<void> addToFavorite(MovieDetail movie) async {
    final result = await saveFavorite.execute(movie);

    await result.fold(
      (failure) async {
        _favoriteMessage = failure.message;
      },
      (successMessage) async {
        _favoriteMessage = successMessage;
      },
    );

    await loadFavoriteStatus(movie.id);
  }

  Future<void> removeFromFavorite(MovieDetail movie) async {
    final result = await removeFavorite.execute(movie);

    await result.fold(
      (failure) async {
        _favoriteMessage = failure.message;
      },
      (successMessage) async {
        _favoriteMessage = successMessage;
      },
    );

    await loadFavoriteStatus(movie.id);
  }

  Future<void> loadFavoriteStatus(int id) async {
    final result = await getFavoriteStatus.execute(id);
    _isAddedToFavorite = result;
    notifyListeners();
  }
}
