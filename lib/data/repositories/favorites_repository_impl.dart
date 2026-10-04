import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/error/guard.dart';
import 'package:cine_vault/data/models/favorite_movie_model.dart';
import 'package:cine_vault/data/repositories/favorites_repository.dart';
import 'package:cine_vault/data/sources/favorites_local_data_source.dart';
import 'package:cine_vault/domain/domain.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({required this.localDataSource});
  final FavoritesLocalDataSource localDataSource;

  @override
  Stream<List<Movie>> watchFavorites() => _watch(_readFavorites);

  @override
  Stream<Set<int>> watchFavoriteIds() => _watch(localDataSource.getAllIds);

  @override
  Future<Result<List<Movie>>> getFavorites() => guard(_readFavorites);

  @override
  Future<Result<bool>> isFavorite(int movieId) => guard(() => localDataSource.isFavorite(movieId));

  @override
  Future<Result<void>> addFavorite(Movie movie) =>
      guard(() => localDataSource.add(FavoriteMovieModel.fromEntity(movie)));

  @override
  Future<Result<void>> removeFavorite(int movieId) => guard(() => localDataSource.remove(movieId));

  @override
  Future<Result<bool>> toggleFavorite(Movie movie) => guard(() async {
    if (await localDataSource.isFavorite(movie.id)) {
      await localDataSource.remove(movie.id);
      return false;
    }
    await localDataSource.add(FavoriteMovieModel.fromEntity(movie));
    return true;
  });

  Future<List<Movie>> _readFavorites() async =>
      (await localDataSource.getAll()).map((f) => f.toEntity()).toList();

  /// Current value first, then a fresh read after every change. Read failures
  /// surface as stream errors (`CacheException`).
  ///
  /// Not an `async*` generator on purpose: cancelling one while it waits in
  /// `await for` only completes after the next change, which would hang
  /// `close()` in the blocs that listen to this.
  Stream<T> _watch<T>(Future<T> Function() read) {
    final ticks = Stream<void>.multi((controller) {
      controller.add(null);
      final changes = localDataSource.watch().listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
      controller.onCancel = changes.cancel;
    });
    return ticks.asyncMap((_) => read());
  }
}
