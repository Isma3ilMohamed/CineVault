import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/movie_repository.dart';
import 'package:cine_vault/domain/models/cast_member.dart';
import 'package:cine_vault/domain/usecases/movies/get_movie_details.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetMovieCredits implements UseCase<List<CastMember>, MovieIdParams> {
  const GetMovieCredits(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<CastMember>>> call(MovieIdParams params) {
    return repository.getMovieCredits(movieId: params.movieId);
  }
}
