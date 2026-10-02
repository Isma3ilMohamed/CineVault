import '../repositories/favorites_repository.dart';

class WatchFavoriteIds {
  final FavoritesRepository repository;

  const WatchFavoriteIds(this.repository);

  Stream<Set<int>> call() => repository.watchFavoriteIds();
}
