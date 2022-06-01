import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/favorite_tv_provider.dart';
import '../widgets/item_card_list.dart';

class TvFavorite extends StatelessWidget {
  const TvFavorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteTvNotifier>(
      builder: (context, data, child) {
        if (data.favoriteState == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (data.favoriteState == RequestState.loaded) {
          return ListView.builder(
            key: const Key('tvFavorite'),
            itemCount: data.favoriteTvs.length,
            itemBuilder: (context, index) {
              final tv = data.favoriteTvs[index];
              return ItemCard(
                tv: tv,
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
