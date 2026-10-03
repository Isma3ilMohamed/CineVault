import 'package:cine_vault/data/models/favorite_movie_model.dart';
import 'package:cine_vault/data/storage/storage_call.dart';
import 'package:hive/hive.dart';

/// Hive box "favorites": key = movieId, value = movie JSON plus `_added_at`.
/// Every method throws a `CacheException` on failure.
abstract class FavoritesLocalDataSource {
  /// Sorted by addedAt, newest first.
  Future<List<FavoriteMovieModel>> getAll();

  Future<Set<int>> getAllIds();

  Future<bool> isFavorite(int movieId);

  Future<void> add(FavoriteMovieModel favorite);

  Future<void> remove(int movieId);

  /// Emits whenever the box changes; listeners re-query.
  Stream<void> watch();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  FavoritesLocalDataSourceImpl(this.box);
  static const String boxName = 'favorites';

  final Box<dynamic> box;

  @override
  Future<List<FavoriteMovieModel>> getAll() => storageCall('read favorites', () {
    final items = [
      for (final key in box.keys.whereType<int>())
        if (box.get(key) case final Map<dynamic, dynamic> raw) FavoriteMovieModel.fromStorage(raw),
    ]..sort((a, b) => b.addedAt.compareTo(a.addedAt));
    return items;
  });

  @override
  Future<Set<int>> getAllIds() =>
      storageCall('read favorite ids', () => box.keys.whereType<int>().toSet());

  @override
  Future<bool> isFavorite(int movieId) =>
      storageCall('check favorite', () => box.containsKey(movieId));

  @override
  Future<void> add(FavoriteMovieModel favorite) =>
      storageCall('add favorite', () => box.put(favorite.movie.id, favorite.toStorage()));

  @override
  Future<void> remove(int movieId) => storageCall('remove favorite', () => box.delete(movieId));

  @override
  Stream<void> watch() => box.watch().map<void>((_) {});
}
