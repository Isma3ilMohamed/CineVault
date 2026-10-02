import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/search/domain/repositories/search_repository.dart';
import 'package:core_result/core_result.dart';

class ClearRecentSearches implements UseCase<void, NoParams> {
  const ClearRecentSearches(this.repository);
  final SearchRepository repository;

  @override
  Future<Result<void>> call(NoParams params) {
    return repository.clearRecentSearches();
  }
}
