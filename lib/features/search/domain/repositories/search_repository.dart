import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';

abstract class SearchRepository {
  Future<Result<List<Movie>>> searchMovies({required String query, required int page});

  Future<Result<List<String>>> getRecentSearches();

  Future<Result<void>> saveRecentSearch(String query);

  Future<Result<void>> clearRecentSearches();
}
