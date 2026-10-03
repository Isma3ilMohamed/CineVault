import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/search_repository.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetRecentSearches implements UseCase<List<String>, NoParams> {
  const GetRecentSearches(this.repository);
  final SearchRepository repository;

  @override
  Future<Result<List<String>>> call(NoParams params) {
    return repository.getRecentSearches();
  }
}
