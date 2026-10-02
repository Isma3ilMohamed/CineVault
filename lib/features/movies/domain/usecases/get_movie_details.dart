import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:cine_vault/features/movies/domain/repositories/movie_repository.dart';
import 'package:core_result/core_result.dart';
import 'package:equatable/equatable.dart';

class GetMovieDetails implements UseCase<Movie, MovieIdParams> {
  const GetMovieDetails(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<Movie>> call(MovieIdParams params) {
    return repository.getMovieDetails(movieId: params.movieId);
  }
}

class MovieIdParams extends Equatable {
  const MovieIdParams({required this.movieId});
  final int movieId;

  @override
  List<Object> get props => [movieId];
}
