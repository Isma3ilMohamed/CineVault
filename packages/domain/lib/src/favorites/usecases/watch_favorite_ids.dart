import 'package:domain/src/favorites/favorites_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchFavoriteIds {
  const WatchFavoriteIds(this.repository);
  final FavoritesRepository repository;

  Stream<Set<int>> call() => repository.watchFavoriteIds();
}
