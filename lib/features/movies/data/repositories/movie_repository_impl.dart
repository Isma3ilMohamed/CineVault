import 'package:cine_vault/core/error/exceptions.dart';
import 'package:cine_vault/core/error/failures.dart';
import 'package:cine_vault/core/network/network_info.dart';
import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/features/movies/data/datasources/remote/movie_remote_data_source.dart';
import 'package:cine_vault/features/movies/data/models/movie_model.dart';
import 'package:cine_vault/features/movies/domain/entities/cast_member.dart';
import 'package:cine_vault/features/movies/domain/entities/genre.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:cine_vault/features/movies/domain/entities/video.dart';
import 'package:cine_vault/features/movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({required this.remoteDataSource, required this.networkInfo});
  final MovieRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Result<List<Movie>>> getPopularMovies({required int page}) {
    return _getMoviesList(() => remoteDataSource.getPopularMovies(page: page));
  }

  @override
  Future<Result<List<Movie>>> getTopRatedMovies({required int page}) {
    return _getMoviesList(() => remoteDataSource.getTopRatedMovies(page: page));
  }

  @override
  Future<Result<List<Movie>>> getUpcomingMovies({required int page}) {
    return _getMoviesList(() => remoteDataSource.getUpcomingMovies(page: page));
  }

  @override
  Future<Result<List<Movie>>> getNowPlayingMovies({required int page}) {
    return _getMoviesList(() => remoteDataSource.getNowPlayingMovies(page: page));
  }

  @override
  Future<Result<List<Movie>>> getTrendingDayMovies({required int page}) {
    return _getMoviesList(() => remoteDataSource.getTrendingDayMovies(page: page));
  }

  @override
  Future<Result<Movie>> getMovieDetails({required int movieId}) async {
    if (!await networkInfo.isConnected) {
      return const Err(NetworkFailure());
    }

    try {
      final movieModel = await remoteDataSource.getMovieDetails(movieId: movieId);
      return Ok(movieModel.toEntity());
    } on ServerException catch (e) {
      return Err(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Err(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Movie>>> getSimilarMovies({required int movieId, required int page}) {
    return _getMoviesList(() => remoteDataSource.getSimilarMovies(movieId: movieId, page: page));
  }

  @override
  Future<Result<List<CastMember>>> getMovieCredits({required int movieId}) async {
    if (!await networkInfo.isConnected) {
      return const Err(NetworkFailure());
    }
    try {
      final response = await remoteDataSource.getMovieCredits(movieId: movieId);
      final cast = response.cast.map((c) => c.toEntity()).toList()
        ..sort((a, b) => a.order.compareTo(b.order));
      return Ok(cast);
    } on ServerException catch (e) {
      return Err(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Err(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Video>>> getMovieVideos({required int movieId}) async {
    if (!await networkInfo.isConnected) {
      return const Err(NetworkFailure());
    }
    try {
      final response = await remoteDataSource.getMovieVideos(movieId: movieId);
      final videos = response.results.map((v) => v.toEntity()).toList();
      return Ok(videos);
    } on ServerException catch (e) {
      return Err(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Err(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Genre>>> getGenres() async {
    if (!await networkInfo.isConnected) {
      return const Err(NetworkFailure());
    }
    try {
      final response = await remoteDataSource.getGenres();
      final genres = response.genres.map((g) => g.toEntity()).toList();
      return Ok(genres);
    } on ServerException catch (e) {
      return Err(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Err(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  Future<Result<List<Movie>>> _getMoviesList(Future<MoviesPageResponse> Function() fetch) async {
    if (!await networkInfo.isConnected) {
      return const Err(NetworkFailure());
    }

    try {
      final response = await fetch();
      final movies = response.results.map((model) => model.toEntity()).toList();
      return Ok(movies);
    } on ServerException catch (e) {
      return Err(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Err(NetworkFailure(message: e.message));
    } on Object catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }
}
