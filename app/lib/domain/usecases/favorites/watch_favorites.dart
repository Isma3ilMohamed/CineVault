import 'package:cine_vault/data/repositories/favorites_repository.dart';
import 'package:cine_vault/domain/models/movie.dart';
import 'package:injectable/injectable.dart';

/// Not a UseCase subclass: returns a Stream; errors are handled in the bloc.
@lazySingleton
class WatchFavorites {
  const WatchFavorites(this.repository);
  final FavoritesRepository repository;

  Stream<List<Movie>> call() => repository.watchFavorites();
}
