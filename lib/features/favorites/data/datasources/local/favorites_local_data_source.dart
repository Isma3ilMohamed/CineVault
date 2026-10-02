import 'package:cine_vault/core/error/exceptions.dart';
import 'package:cine_vault/features/favorites/data/models/favorite_movie_model.dart';
import 'package:hive/hive.dart';

/// Hive box "favorites": key = movieId, value = movie JSON plus `_added_at`.
abstract class FavoritesLocalDataSource {
  /// Sorted by addedAt, newest first.
  List<FavoriteMovieModel> getAll();

  Set<int> getAllIds();

  bool isFavorite(int movieId);

  Future<void> add(FavoriteMovieModel favorite);

  Future<void> remove(int movieId);

  Stream<void> watch();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  FavoritesLocalDataSourceImpl(this.box);
  static const String boxName = 'favorites';

  final Box<dynamic> box;

  @override
  List<FavoriteMovieModel> getAll() {
    try {
      final keys = box.keys.whereType<int>().toList();
      final items = <FavoriteMovieModel>[];
      for (final key in keys) {
        final raw = box.get(key);
        if (raw is Map) {
          items.add(FavoriteMovieModel.fromStorage(raw));
        }
      }
      // newest first
      items.sort((a, b) => b.addedAt.compareTo(a.addedAt));
      return items;
    } catch (e) {
      throw CacheException(message: 'Failed to read favorites: $e');
    }
  }

  @override
  Set<int> getAllIds() {
    try {
      return box.keys.whereType<int>().toSet();
    } catch (e) {
      throw CacheException(message: 'Failed to read favorite ids: $e');
    }
  }

  @override
  bool isFavorite(int movieId) {
    try {
      return box.containsKey(movieId);
    } catch (e) {
      throw CacheException(message: 'Failed to check favorite: $e');
    }
  }

  @override
  Future<void> add(FavoriteMovieModel favorite) async {
    try {
      await box.put(favorite.movie.id, favorite.toStorage());
    } catch (e) {
      throw CacheException(message: 'Failed to add favorite: $e');
    }
  }

  @override
  Future<void> remove(int movieId) async {
    try {
      await box.delete(movieId);
    } catch (e) {
      throw CacheException(message: 'Failed to remove favorite: $e');
    }
  }

  @override
  Stream<void> watch() {
    // The BoxEvent payload is ignored; listeners re-query the box.
    return box.watch().map<void>((_) {});
  }
}
