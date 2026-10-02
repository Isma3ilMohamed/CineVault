import '../../../../core/result/result.dart';
import '../entities/cast_member.dart';
import '../entities/genre.dart';
import '../entities/movie.dart';
import '../entities/video.dart';

/// ببساطة كدا: ده الـ "contract" بين الـ Domain والـ Data
/// الـ Domain بيعرف إن الـ methods دي موجودة
/// بس ما يعرفش إزاي الـ data بتيجي (من API ولا Cache ولا File)
///
/// Compare مع Kee:
///   abstract class MovieRepository {
///     suspend fun getPopular(): `Result<List<Movie>>`
///   }
abstract class MovieRepository {
  Future<Result<List<Movie>>> getPopularMovies({
    required int page,
  });

  Future<Result<List<Movie>>> getTopRatedMovies({
    required int page,
  });

  Future<Result<List<Movie>>> getUpcomingMovies({
    required int page,
  });

  Future<Result<List<Movie>>> getNowPlayingMovies({
    required int page,
  });

  Future<Result<List<Movie>>> getTrendingDayMovies({
    required int page,
  });

  Future<Result<Movie>> getMovieDetails({
    required int movieId,
  });

  Future<Result<List<Movie>>> getSimilarMovies({
    required int movieId,
    required int page,
  });

  Future<Result<List<Genre>>> getGenres();

  Future<Result<List<CastMember>>> getMovieCredits({required int movieId});

  Future<Result<List<Video>>> getMovieVideos({required int movieId});
}
