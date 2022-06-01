import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

class SaveFavoriteMovie {
  final MovieRepository movieRepository;

  SaveFavoriteMovie({required this.movieRepository});

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return movieRepository.saveFavorite(movie);
  }
}
