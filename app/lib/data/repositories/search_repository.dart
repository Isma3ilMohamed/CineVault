import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/domain/models/movie.dart';

abstract class SearchRepository {
  Future<Result<List<Movie>>> searchMovies({required String query, int page = 1});

  Future<Result<List<String>>> getRecentSearches();

  Future<Result<void>> saveRecentSearch(String query);

  Future<Result<void>> clearRecentSearches();
}
