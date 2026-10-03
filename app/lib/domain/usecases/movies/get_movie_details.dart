import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/movie_repository.dart';
import 'package:cine_vault/domain/models/movie.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
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
