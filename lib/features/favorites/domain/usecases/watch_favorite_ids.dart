import '../repositories/favorites_repository.dart';

/// ببساطة كدا: stream للـ ids المفضلة فقط
/// بيتستخدم في الـ FavoriteIdsCubit عشان الـ heart icons
/// على كل card تبقى reactive
class WatchFavoriteIds {
  final FavoritesRepository repository;

  const WatchFavoriteIds(this.repository);

  Stream<Set<int>> call() => repository.watchFavoriteIds();
}
