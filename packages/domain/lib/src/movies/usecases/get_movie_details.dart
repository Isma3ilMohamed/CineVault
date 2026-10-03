import 'package:core_result/core_result.dart';
import 'package:domain/src/movies/entities/movie.dart';
import 'package:domain/src/movies/movie_repository.dart';
import 'package:domain/src/usecase.dart';
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
