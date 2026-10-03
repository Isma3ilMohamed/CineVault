import 'package:core_result/core_result.dart';
import 'package:domain/src/movies/entities/genre.dart';
import 'package:domain/src/movies/movie_repository.dart';
import 'package:domain/src/usecase.dart';

class GetGenres implements UseCase<List<Genre>, NoParams> {
  const GetGenres(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Genre>>> call(NoParams params) {
    return repository.getGenres();
  }
}
