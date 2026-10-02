import '../../../movies/domain/entities/movie.dart';
import '../repositories/favorites_repository.dart';

/// Not a UseCase subclass: returns a Stream; errors are handled in the bloc.
class WatchFavorites {
  final FavoritesRepository repository;

  const WatchFavorites(this.repository);

  Stream<List<Movie>> call() => repository.watchFavorites();
}
