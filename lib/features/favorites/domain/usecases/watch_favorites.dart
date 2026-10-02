import 'package:cine_vault/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';

/// Not a UseCase subclass: returns a Stream; errors are handled in the bloc.
class WatchFavorites {
  const WatchFavorites(this.repository);
  final FavoritesRepository repository;

  Stream<List<Movie>> call() => repository.watchFavorites();
}
