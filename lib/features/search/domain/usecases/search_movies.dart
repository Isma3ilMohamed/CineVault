import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:cine_vault/features/search/domain/repositories/search_repository.dart';
import 'package:core_result/core_result.dart';
import 'package:equatable/equatable.dart';

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
