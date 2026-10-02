import 'package:cine_vault/features/favorites/domain/repositories/favorites_repository.dart';

class WatchFavoriteIds {
  const WatchFavoriteIds(this.repository);
  final FavoritesRepository repository;

  Stream<Set<int>> call() => repository.watchFavoriteIds();
}
