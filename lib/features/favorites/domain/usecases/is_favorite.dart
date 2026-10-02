import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:equatable/equatable.dart';

class IsFavorite implements UseCase<bool, IsFavoriteParams> {
  const IsFavorite(this.repository);
  final FavoritesRepository repository;

  @override
  Future<Result<bool>> call(IsFavoriteParams params) {
    return repository.isFavorite(params.movieId);
  }
}

class IsFavoriteParams extends Equatable {
  const IsFavoriteParams({required this.movieId});
  final int movieId;

  @override
  List<Object> get props => [movieId];
}
