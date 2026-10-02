import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/search_repository.dart';

class SaveRecentSearch implements UseCase<void, SaveRecentSearchParams> {
  final SearchRepository repository;

  const SaveRecentSearch(this.repository);

  @override
  Future<Result<void>> call(SaveRecentSearchParams params) {
    return repository.saveRecentSearch(params.query);
  }
}

class SaveRecentSearchParams extends Equatable {
  final String query;

  const SaveRecentSearchParams({required this.query});

  @override
  List<Object> get props => [query];
}
