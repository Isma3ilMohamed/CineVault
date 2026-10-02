import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/search/domain/repositories/search_repository.dart';
import 'package:equatable/equatable.dart';

class SaveRecentSearch implements UseCase<void, SaveRecentSearchParams> {
  const SaveRecentSearch(this.repository);
  final SearchRepository repository;

  @override
  Future<Result<void>> call(SaveRecentSearchParams params) {
    return repository.saveRecentSearch(params.query);
  }
}

class SaveRecentSearchParams extends Equatable {
  const SaveRecentSearchParams({required this.query});
  final String query;

  @override
  List<Object> get props => [query];
}
