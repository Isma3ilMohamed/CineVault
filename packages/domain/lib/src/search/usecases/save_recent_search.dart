import 'package:core_result/core_result.dart';
import 'package:domain/src/search/search_repository.dart';
import 'package:domain/src/usecase.dart';
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
