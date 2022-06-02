import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_favorite_tvs.dart';

class FavoriteTvNotifier extends ChangeNotifier {
  final GetFavoriteTvs getFavoriteTvs;

  FavoriteTvNotifier({required this.getFavoriteTvs});

  List<Tv> _favoriteTvs = <Tv>[];
  List<Tv> get favoriteTvs => _favoriteTvs;

  RequestState _favoriteState = RequestState.empty;
  RequestState get favoriteState => _favoriteState;

  String _message = '';
  String get message => _message;

  Future<void> fetchFavoriteTvs() async {
    _favoriteState = RequestState.loading;
    notifyListeners();

    final result = await getFavoriteTvs.execute();
    result.fold(
      (failure) {
        _favoriteState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (favoriteTvs) {
        _favoriteState = RequestState.loaded;
        _favoriteTvs = favoriteTvs;
        notifyListeners();
      },
    );
  }
}
