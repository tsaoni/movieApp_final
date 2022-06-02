import '../repositories/tv_repository.dart';

class GetTvFavoriteStatus {
  final TvRepository tvRepository;

  GetTvFavoriteStatus({
    required this.tvRepository,
  });

  Future<bool> execute(int id) async {
    return tvRepository.isAddedToFavorite(id);
  }
}
