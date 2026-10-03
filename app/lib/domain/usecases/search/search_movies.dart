import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/search_repository.dart';
import 'package:cine_vault/domain/models/movie.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SearchMovies implements UseCase<List<Movie>, SearchParams> {
  const SearchMovies(this.repository);
  final SearchRepository repository;

  @override
  Future<Result<List<Movie>>> call(SearchParams params) {
    return repository.searchMovies(query: params.query, page: params.page);
  }
}

class SearchParams extends Equatable {
  const SearchParams({required this.query, this.page = 1});
  final String query;
  final int page;

  @override
  List<Object> get props => [query, page];
}
