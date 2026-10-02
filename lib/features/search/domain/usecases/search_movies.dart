import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../movies/domain/entities/movie.dart';
import '../repositories/search_repository.dart';

class SearchMovies implements UseCase<List<Movie>, SearchParams> {
  final SearchRepository repository;

  const SearchMovies(this.repository);

  @override
  Future<Result<List<Movie>>> call(SearchParams params) {
    return repository.searchMovies(query: params.query, page: params.page);
  }
}

class SearchParams extends Equatable {
  final String query;
  final int page;

  const SearchParams({required this.query, this.page = 1});

  @override
  List<Object> get props => [query, page];
}
