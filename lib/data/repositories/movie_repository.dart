import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/domain/models/cast_member.dart';
import 'package:cine_vault/domain/models/genre.dart';
import 'package:cine_vault/domain/models/movie.dart';
import 'package:cine_vault/domain/models/movie_category.dart';
import 'package:cine_vault/domain/models/video.dart';

abstract class MovieRepository {
  /// One page of the [category] list.
  Future<Result<List<Movie>>> getMoviesByCategory(MovieCategory category, {int page = 1});

  Future<Result<Movie>> getMovieDetails({required int movieId});

  Future<Result<List<Movie>>> getSimilarMovies({required int movieId, int page = 1});

  Future<Result<List<Genre>>> getGenres();

  /// The cast in billing order.
  Future<Result<List<CastMember>>> getMovieCredits({required int movieId});

  /// The best trailer to play, or `null` when the movie has none.
  Future<Result<Video?>> getMovieTrailer({required int movieId});
}
