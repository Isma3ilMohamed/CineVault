import 'package:core_result/core_result.dart';
import 'package:data/src/error/guard.dart';
import 'package:data/src/movies/models/movie_model.dart';
import 'package:data/src/movies/movie_remote_data_source.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: MovieRepository)
class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({required this.remoteDataSource});
  final MovieRemoteDataSource remoteDataSource;

  @override
  Future<Result<List<Movie>>> getPopularMovies({required int page}) =>
      _movies(() => remoteDataSource.getPopularMovies(page: page));

  @override
  Future<Result<List<Movie>>> getTopRatedMovies({required int page}) =>
      _movies(() => remoteDataSource.getTopRatedMovies(page: page));

  @override
  Future<Result<List<Movie>>> getUpcomingMovies({required int page}) =>
      _movies(() => remoteDataSource.getUpcomingMovies(page: page));

  @override
  Future<Result<List<Movie>>> getNowPlayingMovies({required int page}) =>
      _movies(() => remoteDataSource.getNowPlayingMovies(page: page));

  @override
  Future<Result<List<Movie>>> getTrendingDayMovies({required int page}) =>
      _movies(() => remoteDataSource.getTrendingDayMovies(page: page));

  @override
  Future<Result<List<Movie>>> getSimilarMovies({required int movieId, required int page}) =>
      _movies(() => remoteDataSource.getSimilarMovies(movieId: movieId, page: page));

  @override
  Future<Result<Movie>> getMovieDetails({required int movieId}) =>
      guard(() async => (await remoteDataSource.getMovieDetails(movieId: movieId)).toEntity());

  @override
  Future<Result<List<Genre>>> getGenres() => guard(() async {
    final response = await remoteDataSource.getGenres();
    return response.genres.map((g) => g.toEntity()).toList();
  });

  @override
  Future<Result<List<CastMember>>> getMovieCredits({required int movieId}) => guard(() async {
    final response = await remoteDataSource.getMovieCredits(movieId: movieId);
    return response.cast.map((c) => c.toEntity()).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  });

  @override
  Future<Result<List<Video>>> getMovieVideos({required int movieId}) => guard(() async {
    final response = await remoteDataSource.getMovieVideos(movieId: movieId);
    return response.results.map((v) => v.toEntity()).toList();
  });

  Future<Result<List<Movie>>> _movies(Future<MoviesPageResponse> Function() fetch) =>
      guard(() async => (await fetch()).results.map((m) => m.toEntity()).toList());
}
