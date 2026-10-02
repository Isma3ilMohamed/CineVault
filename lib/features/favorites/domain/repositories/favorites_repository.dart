import '../../../../core/result/result.dart';
import '../../../movies/domain/entities/movie.dart';

/// ببساطة كدا: contract بتاع feature الـ Favorites
/// - watchFavorites / watchFavoriteIds: streams reactive
/// - add/remove/toggle: mutations
/// - isFavorite: one-shot check
abstract class FavoritesRepository {
  Stream<List<Movie>> watchFavorites();

  Stream<Set<int>> watchFavoriteIds();

  Future<Result<List<Movie>>> getFavorites();

  Future<Result<bool>> isFavorite(int movieId);

  Future<Result<void>> addFavorite(Movie movie);

  Future<Result<void>> removeFavorite(int movieId);

  /// Convenience: toggle. بيرجع bool = الحالة الجديدة
  Future<Result<bool>> toggleFavorite(Movie movie);
}
