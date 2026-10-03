import 'package:core_result/core_result.dart';
import 'package:domain/src/search/search_repository.dart';
import 'package:domain/src/usecase.dart';
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
