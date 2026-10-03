import 'package:core_result/core_result.dart';
import 'package:domain/src/favorites/favorites_repository.dart';
import 'package:domain/src/movies/entities/movie.dart';
import 'package:domain/src/usecase.dart';
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
