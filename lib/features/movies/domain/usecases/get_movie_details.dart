import 'package:equatable/equatable.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetails implements UseCase<Movie, MovieIdParams> {
  final MovieRepository repository;

  const GetMovieDetails(this.repository);

  @override
  Future<Result<Movie>> call(MovieIdParams params) {
    return repository.getMovieDetails(movieId: params.movieId);
  }
}

class MovieIdParams extends Equatable {
  final int movieId;

  const MovieIdParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
