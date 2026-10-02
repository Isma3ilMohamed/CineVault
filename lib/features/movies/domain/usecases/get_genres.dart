import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/movies/domain/entities/genre.dart';
import 'package:cine_vault/features/movies/domain/repositories/movie_repository.dart';
import 'package:core_result/core_result.dart';

class GetGenres implements UseCase<List<Genre>, NoParams> {
  const GetGenres(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Genre>>> call(NoParams params) {
    return repository.getGenres();
  }
}
