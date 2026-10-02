import '../../../../core/result/result.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class SearchRepository {
  Future<Result<List<Movie>>> searchMovies({
    required String query,
    required int page,
  });

  Future<Result<List<String>>> getRecentSearches();

  Future<Result<void>> saveRecentSearch(String query);

  Future<Result<void>> clearRecentSearches();
}
