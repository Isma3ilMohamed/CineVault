import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/error/guard.dart';
import 'package:cine_vault/data/models/movie_model.dart';
import 'package:cine_vault/data/repositories/movie_repository.dart';
import 'package:cine_vault/data/sources/movie_remote_data_source.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

@LazySingleton(as: MovieRepository)
class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({required this.remoteDataSource});
  final MovieRemoteDataSource remoteDataSource;

  @override
  Future<Result<List<Movie>>> getMoviesByCategory(MovieCategory category, {int page = 1}) =>
      _movies(
        () => switch (category) {
          MovieCategory.trending => remoteDataSource.getTrendingDayMovies(page: page),
          MovieCategory.popular => remoteDataSource.getPopularMovies(page: page),
          MovieCategory.topRated => remoteDataSource.getTopRatedMovies(page: page),
          MovieCategory.nowPlaying => remoteDataSource.getNowPlayingMovies(page: page),
          MovieCategory.upcoming => remoteDataSource.getUpcomingMovies(page: page),
        },
      );

  @override
  Future<Result<List<Movie>>> getSimilarMovies({required int movieId, int page = 1}) =>
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
  Future<Result<Video?>> getMovieTrailer({required int movieId}) => guard(() async {
    final response = await remoteDataSource.getMovieVideos(movieId: movieId);
    return pickTrailer(response.results.map((v) => v.toEntity()).toList());
  });

  /// Only YouTube videos with a key are playable. Preference: an official
  /// trailer, then any trailer, then any video.
  @visibleForTesting
  static Video? pickTrailer(List<Video> videos) {
    final playable = videos.where((v) => v.isYouTube && v.key.isNotEmpty).toList();
    return playable.where((v) => v.isTrailer && v.official).firstOrNull ??
        playable.where((v) => v.isTrailer).firstOrNull ??
        playable.firstOrNull;
  }

  Future<Result<List<Movie>>> _movies(Future<MoviesPageResponse> Function() fetch) =>
      guard(() async => (await fetch()).results.map((m) => m.toEntity()).toList());
}
