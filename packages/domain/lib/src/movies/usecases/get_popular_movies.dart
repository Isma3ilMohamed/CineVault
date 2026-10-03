import 'package:core_result/core_result.dart';
import 'package:domain/src/movies/entities/movie.dart';
import 'package:domain/src/movies/movie_repository.dart';
import 'package:domain/src/usecase.dart';
import 'package:equatable/equatable.dart';

class GetPopularMovies implements UseCase<List<Movie>, PageParams> {
  const GetPopularMovies(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Movie>>> call(PageParams params) {
    return repository.getPopularMovies(page: params.page);
  }
}

class PageParams extends Equatable {
  const PageParams({required this.page});
  final int page;

  @override
  List<Object> get props => [page];
}
