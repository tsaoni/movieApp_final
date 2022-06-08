import 'package:flutter/material.dart';
import 'package:movie/movie.dart';
import 'package:provider/provider.dart';
import 'package:tv/tv.dart';
import '../../core.dart';

class FavoritePage extends StatefulWidget {
  static const routeName = '/favorite';

  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<FavoriteMovieNotifier>(context, listen: false)
            .fetchFavoriteMovies());
    Future.microtask(() =>
        Provider.of<FavoriteTvNotifier>(context, listen: false)
            .fetchFavoriteTvs());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<FavoriteMovieNotifier>(context, listen: false)
        .fetchFavoriteMovies();
    Provider.of<FavoriteTvNotifier>(context, listen: false)
        .fetchFavoriteTvs();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(300.0),
            child: AppBar(
              title: Text('Favorite',),
              flexibleSpace: Container(
                color: Colors.white,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 85,
                      color: Color.fromRGBO(116, 196, 199, 1),
                    ),
                    SizedBox(height: 50),
                    Container(
                      width: 100,
                      height: 100,
                      color: Color.fromRGBO(116, 196, 199, 1),
                    )
                  ],
                ),
              ),
              bottom: const TabBar(
                labelColor: Color.fromRGBO(116, 196, 199, 1),
                tabs: [
                  Tab(
                    key: Key('movieFavoriteTab'),
                    text: 'Movie',
                  ),
                  Tab(
                    key: Key('tvFavoriteTab'),
                    text: 'Tv',
                  ),
                ],
                indicatorColor: Color.fromRGBO(116, 196, 199, 1),
                indicatorWeight: 4.0,
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              MovieFavorite(),
              TvFavorite(),
            ],
          ),
        )
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
