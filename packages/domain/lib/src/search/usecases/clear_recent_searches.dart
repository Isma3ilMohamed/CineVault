import 'package:core_result/core_result.dart';
import 'package:domain/src/search/search_repository.dart';
import 'package:domain/src/usecase.dart';

class ClearRecentSearches implements UseCase<void, NoParams> {
  const ClearRecentSearches(this.repository);
  final SearchRepository repository;

  @override
  Future<Result<void>> call(NoParams params) {
    return repository.clearRecentSearches();
  }
}
