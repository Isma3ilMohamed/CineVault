import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/movie_repository.dart';
import 'package:cine_vault/domain/models/genre.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetGenres implements UseCase<List<Genre>, NoParams> {
  const GetGenres(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Genre>>> call(NoParams params) {
    return repository.getGenres();
  }
}
