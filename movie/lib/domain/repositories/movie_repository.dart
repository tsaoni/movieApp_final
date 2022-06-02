import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/media_image.dart';
import '../entities/movie.dart';
import '../entities/movie_detail.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();
  Future<Either<Failure, List<Movie>>> getPopularMovies();
  Future<Either<Failure, List<Movie>>> getTopRatedMovies();
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id);
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, MediaImage>> getMovieImages(int id);
  Future<Either<Failure, String>> saveFavorite(MovieDetail movie);
  Future<Either<Failure, String>> removeFavorite(MovieDetail movie);
  Future<bool> isAddedToFavorite(int id);
  Future<Either<Failure, List<Movie>>> getFavoriteMovies();
}
