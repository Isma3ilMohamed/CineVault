import 'package:domain/src/favorites/favorites_repository.dart';

class WatchFavoriteIds {
  const WatchFavoriteIds(this.repository);
  final FavoritesRepository repository;

  Stream<Set<int>> call() => repository.watchFavoriteIds();
}
