import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:cine_vault/features/movies/domain/repositories/movie_repository.dart';
import 'package:core_result/core_result.dart';
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
