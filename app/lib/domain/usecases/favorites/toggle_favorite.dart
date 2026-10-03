import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/favorites_repository.dart';
import 'package:cine_vault/domain/models/movie.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ToggleFavorite implements UseCase<bool, ToggleFavoriteParams> {
  const ToggleFavorite(this.repository);
  final FavoritesRepository repository;

  @override
  Future<Result<bool>> call(ToggleFavoriteParams params) {
    return repository.toggleFavorite(params.movie);
  }
}

class ToggleFavoriteParams extends Equatable {
  const ToggleFavoriteParams({required this.movie});
  final Movie movie;

  @override
  List<Object> get props => [movie.id];
}
