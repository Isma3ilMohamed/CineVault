import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/search_repository.dart';

class ClearRecentSearches implements UseCase<void, NoParams> {
  final SearchRepository repository;

  const ClearRecentSearches(this.repository);

  @override
  Future<Result<void>> call(NoParams params) {
    return repository.clearRecentSearches();
  }
}
