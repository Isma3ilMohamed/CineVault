import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/video.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/remote/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<List<Movie>>> getPopularMovies({required int page}) async {
    return _getMoviesList(
      () => remoteDataSource.getPopularMovies(page: page),
    );
  }

  @override
  Future<Result<List<Movie>>> getTopRatedMovies({required int page}) async {
    return _getMoviesList(
      () => remoteDataSource.getTopRatedMovies(page: page),
    );
  }

  @override
  Future<Result<List<Movie>>> getUpcomingMovies({required int page}) async {
    return _getMoviesList(
      () => remoteDataSource.getUpcomingMovies(page: page),
    );
  }

  @override
  Future<Result<List<Movie>>> getNowPlayingMovies({required int page}) async {
    return _getMoviesList(
      () => remoteDataSource.getNowPlayingMovies(page: page),
    );
  }

  @override
  Future<Result<List<Movie>>> getTrendingDayMovies({required int page}) async {
    return _getMoviesList(
      () => remoteDataSource.getTrendingDayMovies(page: page),
    );
  }

  @override
  Future<Result<Movie>> getMovieDetails({required int movieId}) async {
    if (!await networkInfo.isConnected) {
      return const Err(NetworkFailure());
    }

    try {
      final movieModel = await remoteDataSource.getMovieDetails(
        movieId: movieId,
      );
      return Ok(movieModel.toEntity());
    } on ServerException catch (e) {
      return Err(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Err(NetworkFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Movie>>> getSimilarMovies({
    required int movieId,
    required int page,
  }) async {
    return _getMoviesList(
      () => remoteDataSource.getSimilarMovies(movieId: movieId, page: page),
    );
  }

  @override
  Future<Result<List<CastMember>>> getMovieCredits({
    required int movieId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Err(NetworkFailure());
    }
    try {
      final response =
          await remoteDataSource.getMovieCredits(movieId: movieId);
      final cast = response.cast.map((c) => c.toEntity()).toList()
        ..sort((a, b) => a.order.compareTo(b.order));
      return Ok(cast);
    } on ServerException catch (e) {
      return Err(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Err(NetworkFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Video>>> getMovieVideos({required int movieId}) async {
    if (!await networkInfo.isConnected) {
      return const Err(NetworkFailure());
    }
    try {
      final response =
          await remoteDataSource.getMovieVideos(movieId: movieId);
      final videos = response.results.map((v) => v.toEntity()).toList();
      return Ok(videos);
    } on ServerException catch (e) {
      return Err(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Err(NetworkFailure(message: e.message));
    } catch (e) {
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
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }

  Future<Result<List<Movie>>> _getMoviesList(
    Future<dynamic> Function() fetch,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Err(NetworkFailure());
    }

    try {
      final response = await fetch();
      final movies = (response.results as List)
          .map((model) => model.toEntity() as Movie)
          .toList();
      return Ok(movies);
    } on ServerException catch (e) {
      return Err(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Err(NetworkFailure(message: e.message));
    } catch (e) {
      return Err(UnknownFailure(message: e.toString()));
    }
  }
}
