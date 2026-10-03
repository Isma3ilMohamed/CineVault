import 'package:core_result/core_result.dart';
import 'package:domain/src/movies/entities/movie.dart';

abstract class FavoritesRepository {
  Stream<List<Movie>> watchFavorites();

  Stream<Set<int>> watchFavoriteIds();

  Future<Result<List<Movie>>> getFavorites();

  Future<Result<bool>> isFavorite(int movieId);

  Future<Result<void>> addFavorite(Movie movie);

  Future<Result<void>> removeFavorite(int movieId);

  /// Returns the new state (true = now a favorite).
  Future<Result<bool>> toggleFavorite(Movie movie);
}
