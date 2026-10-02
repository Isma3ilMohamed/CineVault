import 'package:cine_vault/core/error/exceptions.dart';
import 'package:cine_vault/core/error/failures.dart';
import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/features/favorites/data/datasources/local/favorites_local_data_source.dart';
import 'package:cine_vault/features/favorites/data/models/favorite_movie_model.dart';
import 'package:cine_vault/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({required this.localDataSource});
  final FavoritesLocalDataSource localDataSource;

  @override
  Stream<List<Movie>> watchFavorites() async* {
    yield _readFavorites();
    await for (final _ in localDataSource.watch()) {
      yield _readFavorites();
    }
  }

  @override
  Stream<Set<int>> watchFavoriteIds() async* {
    yield _readIds();
    await for (final _ in localDataSource.watch()) {
      yield _readIds();
    }
  }

  @override
  Future<Result<List<Movie>>> getFavorites() async {
    try {
      return Ok(_readFavorites());
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<bool>> isFavorite(int movieId) async {
    try {
      return Ok(localDataSource.isFavorite(movieId));
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> addFavorite(Movie movie) async {
    try {
      await localDataSource.add(FavoriteMovieModel.fromEntity(movie));
      return const Ok(null);
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> removeFavorite(int movieId) async {
    try {
      await localDataSource.remove(movieId);
      return const Ok(null);
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<bool>> toggleFavorite(Movie movie) async {
    try {
      final wasFavorite = localDataSource.isFavorite(movie.id);
      if (wasFavorite) {
        await localDataSource.remove(movie.id);
        return const Ok(false);
      } else {
        await localDataSource.add(FavoriteMovieModel.fromEntity(movie));
        return const Ok(true);
      }
    } on CacheException catch (e) {
      return Err(CacheFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  List<Movie> _readFavorites() => localDataSource.getAll().map((f) => f.toEntity()).toList();

  Set<int> _readIds() => localDataSource.getAllIds();
}
