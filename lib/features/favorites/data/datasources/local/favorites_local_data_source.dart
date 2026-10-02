import 'package:hive/hive.dart';

import '../../../../../core/error/exceptions.dart';
import '../../models/favorite_movie_model.dart';

/// ببساطة كدا: الـ local store للـ favorites
/// Hive box اسمه "favorites" بيخزن:
///   key: int (movieId)
///   value: `Map<String, dynamic>` (Movie JSON + _added_at)
///
/// الميزة الأساسية: box.watch() بيطلع stream بيطلق event
/// مع كل write → UI هيعمل rebuild تلقائي
abstract class FavoritesLocalDataSource {
  /// كل الأفلام المفضلة — مرتبة بـ addedAt descending (الأحدث الأول)
  List<FavoriteMovieModel> getAll();

  /// الـ ids بس — للـ heart icons على كل card (O(1) lookup)
  Set<int> getAllIds();

  bool isFavorite(int movieId);

  Future<void> add(FavoriteMovieModel favorite);

  Future<void> remove(int movieId);

  /// Stream بينبعت event كل لما الـ box يتعدل
  /// الـ listener بيستخدمه عشان يعيد query للـ data
  Stream<void> watch();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  static const String boxName = 'favorites';

  final Box<dynamic> box;

  FavoritesLocalDataSourceImpl(this.box);

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
    // box.watch() بيرجع BoxEvent — بنتجاهل الـ payload ونبعت void
    return box.watch().map<void>((_) {});
  }
}
