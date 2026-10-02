import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../movies/domain/entities/movie.dart';
import '../repositories/favorites_repository.dart';

/// ببساطة كدا: يقلب حالة الـ favorite لفيلم
/// بيرجع الحالة الجديدة (true = أصبح favorite)
class ToggleFavorite implements UseCase<bool, ToggleFavoriteParams> {
  final FavoritesRepository repository;

  const ToggleFavorite(this.repository);

  @override
  Future<Result<bool>> call(ToggleFavoriteParams params) {
    return repository.toggleFavorite(params.movie);
  }
}

class ToggleFavoriteParams extends Equatable {
  final Movie movie;

  const ToggleFavoriteParams({required this.movie});

  @override
  List<Object> get props => [movie.id];
}
