import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:cine_vault/features/movies/domain/repositories/movie_repository.dart';
import 'package:equatable/equatable.dart';

class GetSimilarMovies implements UseCase<List<Movie>, SimilarMoviesParams> {
  const GetSimilarMovies(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Movie>>> call(SimilarMoviesParams params) {
    return repository.getSimilarMovies(movieId: params.movieId, page: params.page);
  }
}

class SimilarMoviesParams extends Equatable {
  const SimilarMoviesParams({required this.movieId, this.page = 1});
  final int movieId;
  final int page;

  @override
  List<Object> get props => [movieId, page];
}
