import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/search_repository.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
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
