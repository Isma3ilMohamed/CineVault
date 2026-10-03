import 'package:core_result/core_result.dart';
import 'package:domain/src/movies/entities/cast_member.dart';
import 'package:domain/src/movies/entities/genre.dart';
import 'package:domain/src/movies/entities/movie.dart';
import 'package:domain/src/movies/entities/video.dart';

abstract class MovieRepository {
  Future<Result<List<Movie>>> getPopularMovies({required int page});

  Future<Result<List<Movie>>> getTopRatedMovies({required int page});

  Future<Result<List<Movie>>> getUpcomingMovies({required int page});

  Future<Result<List<Movie>>> getNowPlayingMovies({required int page});

  Future<Result<List<Movie>>> getTrendingDayMovies({required int page});

  Future<Result<Movie>> getMovieDetails({required int movieId});

  Future<Result<List<Movie>>> getSimilarMovies({required int movieId, required int page});

  Future<Result<List<Genre>>> getGenres();

  Future<Result<List<CastMember>>> getMovieCredits({required int movieId});

  Future<Result<List<Video>>> getMovieVideos({required int movieId});
}
