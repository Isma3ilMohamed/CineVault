import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/search_repository.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ClearRecentSearches implements UseCase<void, NoParams> {
  const ClearRecentSearches(this.repository);
  final SearchRepository repository;

  @override
  Future<Result<void>> call(NoParams params) {
    return repository.clearRecentSearches();
  }
}
