import '../../../../core/result/result.dart';
import '../../../movies/domain/entities/movie.dart';

/// ببساطة كدا: contract بتاع feature الـ Search
/// - searchMovies: بيرجع نتيجة pagination من الـ API
/// - recent searches: بيتخزنوا locally
abstract class SearchRepository {
  Future<Result<List<Movie>>> searchMovies({
    required String query,
    required int page,
  });

  Future<Result<List<String>>> getRecentSearches();

  Future<Result<void>> saveRecentSearch(String query);

  Future<Result<void>> clearRecentSearches();
}
