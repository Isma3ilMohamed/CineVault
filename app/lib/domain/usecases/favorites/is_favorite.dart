import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/favorites_repository.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
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
