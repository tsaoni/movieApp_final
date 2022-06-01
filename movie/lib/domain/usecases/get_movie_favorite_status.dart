import '../repositories/movie_repository.dart';

class GetMovieFavoriteStatus {
  final MovieRepository movieRepository;

  GetMovieFavoriteStatus({
    required this.movieRepository,
  });

  Future<bool> execute(int id) async {
    return movieRepository.isAddedToFavorite(id);
  }
}
