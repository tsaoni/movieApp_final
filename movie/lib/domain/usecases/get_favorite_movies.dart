import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetFavoriteMovies {
  final MovieRepository _repository;

  GetFavoriteMovies(this._repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return _repository.getFavoriteMovies();
  }
}
