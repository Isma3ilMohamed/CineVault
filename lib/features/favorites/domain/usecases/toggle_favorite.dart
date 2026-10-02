import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:core_result/core_result.dart';
import 'package:equatable/equatable.dart';

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
