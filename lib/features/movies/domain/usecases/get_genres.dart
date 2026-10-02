import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/genre.dart';
import '../repositories/movie_repository.dart';

class GetGenres implements UseCase<List<Genre>, NoParams> {
  final MovieRepository repository;

  const GetGenres(this.repository);

  @override
  Future<Result<List<Genre>>> call(NoParams params) {
    return repository.getGenres();
  }
}
