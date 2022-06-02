import 'package:core/presentation/provider/home_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movie/data/datasources/db/movie_database_helper.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/data/repositories/movie_repository_impl.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_images.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_movie_favorite_status.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/domain/usecases/get_favorite_movies.dart';
import 'package:movie/domain/usecases/remove_favorite_movie.dart';
import 'package:movie/domain/usecases/save_favorite_movie.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:movie/presentation/provider/movie_images_notifier.dart';
import 'package:movie/presentation/provider/movie_list_notifier.dart';
import 'package:movie/presentation/provider/popular_movies_notifier.dart';
import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:movie/presentation/provider/favorite_movie_notifier.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_tvs.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:tv/data/datasources/db/tv_database_helper.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_images.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_tv_season_episodes.dart';
import 'package:tv/domain/usecases/get_tv_favorite_status.dart';
import 'package:tv/domain/usecases/get_favorite_tvs.dart';
import 'package:tv/domain/usecases/remove_favorite_tv.dart';
import 'package:tv/domain/usecases/save_favorite_tv.dart';
import 'package:tv/presentation/provider/popular_tvs_notifier.dart';
import 'package:tv/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:tv/presentation/provider/tv_detail_notifier.dart';
import 'package:tv/presentation/provider/tv_images_notifier.dart';
import 'package:tv/presentation/provider/tv_list_notifier.dart';
import 'package:tv/presentation/provider/tv_season_episodes_notifier.dart';
import 'package:tv/presentation/provider/favorite_tv_provider.dart';

final locator = GetIt.instance;

void init() {
  locator.registerFactory(() => MovieSearchBloc(locator()));
  locator.registerFactory(() => TvSearchBloc(locator()));

  // provider
  locator.registerFactory(() => HomeNotifier());

  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getFavoriteStatus: locator(),
      saveFavorite: locator(),
      removeFavorite: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieImagesNotifier(
      getMovieImages: locator(),
    ),
  );
  locator.registerFactory(
    () => FavoriteMovieNotifier(
      getFavoriteMovies: locator(),
    ),
  );

  locator.registerFactory(
    () => TvListNotifier(
      getOnTheAirTvs: locator(),
      getPopularTvs: locator(),
      getTopRatedTvs: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvsNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvsNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvDetailNotifier(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getFavoriteStatus: locator(),
      saveFavorite: locator(),
      removeFavorite: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeasonEpisodesNotifier(
      getTvSeasonEpisodes: locator(),
    ),
  );
  locator.registerFactory(
    () => TvImagesNotifier(
      getTvImages: locator(),
    ),
  );
  locator.registerFactory(
    () => FavoriteTvNotifier(
      getFavoriteTvs: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetMovieImages(locator()));
  locator.registerLazySingleton(() => GetFavoriteMovies(locator()));

  locator.registerLazySingleton(() => GetOnTheAirTvs(locator()));
  locator.registerLazySingleton(() => GetPopularTvs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvs(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeasonEpisodes(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvs(locator()));
  locator.registerLazySingleton(() => GetTvImages(locator()));
  locator.registerLazySingleton(() => GetFavoriteTvs(locator()));

  locator.registerLazySingleton(
    () => GetMovieFavoriteStatus(
      movieRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTvFavoriteStatus(
      tvRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SaveFavoriteMovie(
      movieRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SaveFavoriteTv(
      tvRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => RemoveFavoriteMovie(
      movieRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => RemoveFavoriteTv(
      tvRepository: locator(),
    ),
  );

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
    () => TvLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  locator.registerLazySingleton<MovieDatabaseHelper>(
    () => MovieDatabaseHelper(),
  );
  locator.registerLazySingleton<TvDatabaseHelper>(
    () => TvDatabaseHelper(),
  );

  // external
  locator.registerLazySingleton(() => http.Client());
}
