import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/search_repository.dart';

class GetRecentSearches implements UseCase<List<String>, NoParams> {
  final SearchRepository repository;

  const GetRecentSearches(this.repository);

  @override
  Future<Result<List<String>>> call(NoParams params) {
    return repository.getRecentSearches();
  }
}
