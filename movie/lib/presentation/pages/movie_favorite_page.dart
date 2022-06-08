import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/favorite_movie_notifier.dart';
import '../widgets/item_card_list.dart';

class MovieFavorite extends StatelessWidget {
  const MovieFavorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteMovieNotifier>(
      builder: (context, data, child) {
        if (data.favoriteState == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (data.favoriteState == RequestState.loaded) {
          return ListView.builder(
            key: const Key('movieFavorite'),
            itemCount: data.favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = data.favoriteMovies[index];
              return ItemCard(
                movie: movie,
              );
            },
          );
        } else {
          return Center(
            key: const Key('error_message'),
            child: Text(data.message),
          );
        }
      },
    );
  }
}
