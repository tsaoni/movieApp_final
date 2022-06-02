import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';
import '../../domain/usecases/get_tv_detail.dart';
import '../../domain/usecases/get_tv_recommendations.dart';
import '../../domain/usecases/get_tv_favorite_status.dart';
import '../../domain/usecases/remove_favorite_tv.dart';
import '../../domain/usecases/save_favorite_tv.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const favoriteAddSuccessMessage = 'Added to favorite';
  static const favoriteRemoveSuccessMessage = 'Removed from favorite';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetTvFavoriteStatus getFavoriteStatus;
  final SaveFavoriteTv saveFavorite;
  final RemoveFavoriteTv removeFavorite;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getFavoriteStatus,
    required this.saveFavorite,
    required this.removeFavorite,
  });

  late TvDetail _tv;
  TvDetail get tv => _tv;

  RequestState _tvState = RequestState.empty;
  RequestState get tvState => _tvState;

  List<Tv> _recommendations = [];
  List<Tv> get recommendations => _recommendations;

  RequestState _recommendationsState = RequestState.empty;
  RequestState get recommendationsState => _recommendationsState;

  String _message = '';
  String get message => _message;

  bool _isAddedToFavorite = false;
  bool get isAddedToFavorite => _isAddedToFavorite;

  String _favoriteMessage = '';
  String get favoriteMessage => _favoriteMessage;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.loading;
    notifyListeners();

    final detailResult = await getTvDetail.execute(id);
    final recommendationsResult = await getTvRecommendations.execute(id);

    detailResult.fold(
      (failure) {
        _tvState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _recommendationsState = RequestState.loading;
        _tvState = RequestState.loaded;
        _tv = tv;
        notifyListeners();
        recommendationsResult.fold(
          (failure) {
            _recommendationsState = RequestState.error;
            _message = failure.message;
          },
          (tvs) {
            _recommendationsState = RequestState.loaded;
            _recommendations = tvs;
          },
        );
        notifyListeners();
      },
    );
  }

  Future<void> addToFavorite(TvDetail tv) async {
    final result = await saveFavorite.execute(tv);

    await result.fold(
      (failure) async {
        _favoriteMessage = failure.message;
      },
      (successMessage) async {
        _favoriteMessage = successMessage;
      },
    );

    await loadFavoriteStatus(tv.id);
  }

  Future<void> removeFromFavorite(TvDetail tv) async {
    final result = await removeFavorite.execute(tv);

    await result.fold(
      (failure) async {
        _favoriteMessage = failure.message;
      },
      (successMessage) async {
        _favoriteMessage = successMessage;
      },
    );

    await loadFavoriteStatus(tv.id);
  }

  Future<void> loadFavoriteStatus(int id) async {
    final result = await getFavoriteStatus.execute(id);
    _isAddedToFavorite = result;
    notifyListeners();
  }
}
