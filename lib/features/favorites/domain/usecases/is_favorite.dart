import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/favorites_repository.dart';

/// ببساطة كدا: snapshot واحد — هل الفيلم ده favorite؟
class IsFavorite implements UseCase<bool, IsFavoriteParams> {
  final FavoritesRepository repository;

  const IsFavorite(this.repository);

  @override
  Future<Result<bool>> call(IsFavoriteParams params) {
    return repository.isFavorite(params.movieId);
  }
}

class IsFavoriteParams extends Equatable {
  final int movieId;

  const IsFavoriteParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
