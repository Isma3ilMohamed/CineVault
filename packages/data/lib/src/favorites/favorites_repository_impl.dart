import 'package:core_result/core_result.dart';
import 'package:data/src/error/guard.dart';
import 'package:data/src/favorites/favorite_movie_model.dart';
import 'package:data/src/favorites/favorites_local_data_source.dart';
import 'package:domain/domain.dart';

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
  Stream<T> _watch<T>(Future<T> Function() read) async* {
    yield await read();
    await for (final _ in localDataSource.watch()) {
      yield await read();
    }
  }
}
