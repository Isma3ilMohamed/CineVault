import 'package:cine_vault/core/constants/api_endpoints.dart';
import 'package:cine_vault/data/models/cast_member_model.dart';
import 'package:cine_vault/data/models/genre_model.dart';
import 'package:cine_vault/data/models/movie_model.dart';
import 'package:cine_vault/data/models/video_model.dart';
import 'package:cine_vault/data/network/process_call.dart';
import 'package:dio/dio.dart';

/// TMDB movie endpoints. Every method throws an `AppException` on failure.
abstract class MovieRemoteDataSource {
  Future<MoviesPageResponse> getPopularMovies({required int page});
  Future<MoviesPageResponse> getTopRatedMovies({required int page});
  Future<MoviesPageResponse> getUpcomingMovies({required int page});
  Future<MoviesPageResponse> getNowPlayingMovies({required int page});
  Future<MoviesPageResponse> getTrendingDayMovies({required int page});
  Future<MovieModel> getMovieDetails({required int movieId});
  Future<MoviesPageResponse> getSimilarMovies({required int movieId, required int page});
  Future<GenresResponse> getGenres();
  Future<CreditsResponse> getMovieCredits({required int movieId});
  Future<VideosResponse> getMovieVideos({required int movieId});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  MovieRemoteDataSourceImpl(this.dio);
  final Dio dio;

  @override
  Future<MoviesPageResponse> getPopularMovies({required int page}) =>
      _moviesPage(ApiEndpoints.popularMovies, page);

  @override
  Future<MoviesPageResponse> getTopRatedMovies({required int page}) =>
      _moviesPage(ApiEndpoints.topRatedMovies, page);

  @override
  Future<MoviesPageResponse> getUpcomingMovies({required int page}) =>
      _moviesPage(ApiEndpoints.upcomingMovies, page);

  @override
  Future<MoviesPageResponse> getNowPlayingMovies({required int page}) =>
      _moviesPage(ApiEndpoints.nowPlayingMovies, page);

  @override
  Future<MoviesPageResponse> getTrendingDayMovies({required int page}) =>
      _moviesPage(ApiEndpoints.trendingDay, page);

  @override
  Future<MovieModel> getMovieDetails({required int movieId}) =>
      processCall(() => dio.get<dynamic>(ApiEndpoints.movie(movieId)), decode: MovieModel.fromJson);

  @override
  Future<MoviesPageResponse> getSimilarMovies({required int movieId, required int page}) =>
      _moviesPage(ApiEndpoints.similar(movieId), page);

  @override
  Future<GenresResponse> getGenres() => processCall(
    () => dio.get<dynamic>(ApiEndpoints.genres, queryParameters: {'language': 'en-US'}),
    decode: GenresResponse.fromJson,
  );

  @override
  Future<CreditsResponse> getMovieCredits({required int movieId}) => processCall(
    () => dio.get<dynamic>(ApiEndpoints.credits(movieId)),
    decode: CreditsResponse.fromJson,
  );

  @override
  Future<VideosResponse> getMovieVideos({required int movieId}) => processCall(
    () => dio.get<dynamic>(ApiEndpoints.videos(movieId)),
    decode: VideosResponse.fromJson,
  );

  Future<MoviesPageResponse> _moviesPage(String endpoint, int page) => processCall(
    () => dio.get<dynamic>(endpoint, queryParameters: {'page': page, 'language': 'en-US'}),
    decode: MoviesPageResponse.fromJson,
  );
}
