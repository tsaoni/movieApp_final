import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/tv_detail.dart';
import '../repositories/tv_repository.dart';

class RemoveFavoriteTv {
  final TvRepository tvRepository;

  RemoveFavoriteTv({required this.tvRepository});

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return tvRepository.removeFavorite(tv);
  }
}
