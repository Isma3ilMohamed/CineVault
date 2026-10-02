import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/movies/domain/entities/genre.dart';
import 'package:cine_vault/features/movies/domain/repositories/movie_repository.dart';

class GetGenres implements UseCase<List<Genre>, NoParams> {
  const GetGenres(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Genre>>> call(NoParams params) {
    return repository.getGenres();
  }
}
