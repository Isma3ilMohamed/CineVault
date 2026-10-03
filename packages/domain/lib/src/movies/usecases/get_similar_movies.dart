import 'package:core_result/core_result.dart';
import 'package:domain/src/movies/entities/movie.dart';
import 'package:domain/src/movies/movie_repository.dart';
import 'package:domain/src/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
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
