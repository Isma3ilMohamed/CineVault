import 'package:data/src/movies/models/cast_member_model.dart';
import 'package:data/src/movies/models/genre_model.dart';
import 'package:data/src/movies/models/movie_model.dart';
import 'package:data/src/movies/models/video_model.dart';
import 'package:data/src/network/process_call.dart';
import 'package:data/src/network/tmdb_endpoints.dart';
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
      _moviesPage(TmdbEndpoints.popularMovies, page);

  @override
  Future<MoviesPageResponse> getTopRatedMovies({required int page}) =>
      _moviesPage(TmdbEndpoints.topRatedMovies, page);

  @override
  Future<MoviesPageResponse> getUpcomingMovies({required int page}) =>
      _moviesPage(TmdbEndpoints.upcomingMovies, page);

  @override
  Future<MoviesPageResponse> getNowPlayingMovies({required int page}) =>
      _moviesPage(TmdbEndpoints.nowPlayingMovies, page);

  @override
  Future<MoviesPageResponse> getTrendingDayMovies({required int page}) =>
      _moviesPage(TmdbEndpoints.trendingDay, page);

  @override
  Future<MovieModel> getMovieDetails({required int movieId}) => processCall(
    () => dio.get<dynamic>(TmdbEndpoints.movie(movieId)),
    decode: MovieModel.fromJson,
  );

  @override
  Future<MoviesPageResponse> getSimilarMovies({required int movieId, required int page}) =>
      _moviesPage(TmdbEndpoints.similar(movieId), page);

  @override
  Future<GenresResponse> getGenres() => processCall(
    () => dio.get<dynamic>(TmdbEndpoints.genres, queryParameters: {'language': 'en-US'}),
    decode: GenresResponse.fromJson,
  );

  @override
  Future<CreditsResponse> getMovieCredits({required int movieId}) => processCall(
    () => dio.get<dynamic>(TmdbEndpoints.credits(movieId)),
    decode: CreditsResponse.fromJson,
  );

  @override
  Future<VideosResponse> getMovieVideos({required int movieId}) => processCall(
    () => dio.get<dynamic>(TmdbEndpoints.videos(movieId)),
    decode: VideosResponse.fromJson,
  );

  Future<MoviesPageResponse> _moviesPage(String endpoint, int page) => processCall(
    () => dio.get<dynamic>(endpoint, queryParameters: {'page': page, 'language': 'en-US'}),
    decode: MoviesPageResponse.fromJson,
  );
}
