import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/search/domain/repositories/search_repository.dart';
import 'package:core_result/core_result.dart';

class GetRecentSearches implements UseCase<List<String>, NoParams> {
  const GetRecentSearches(this.repository);
  final SearchRepository repository;

  @override
  Future<Result<List<String>>> call(NoParams params) {
    return repository.getRecentSearches();
  }
}
