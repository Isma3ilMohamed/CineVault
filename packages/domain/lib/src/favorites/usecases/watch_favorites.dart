import 'package:domain/src/favorites/favorites_repository.dart';
import 'package:domain/src/movies/entities/movie.dart';

/// Not a UseCase subclass: returns a Stream; errors are handled in the bloc.
class WatchFavorites {
  const WatchFavorites(this.repository);
  final FavoritesRepository repository;

  Stream<List<Movie>> call() => repository.watchFavorites();
}
