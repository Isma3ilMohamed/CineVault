import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/movies/domain/entities/cast_member.dart';
import 'package:cine_vault/features/movies/domain/repositories/movie_repository.dart';
import 'package:cine_vault/features/movies/domain/usecases/get_movie_details.dart';
import 'package:core_result/core_result.dart';

class GetMovieCredits implements UseCase<List<CastMember>, MovieIdParams> {
  const GetMovieCredits(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<CastMember>>> call(MovieIdParams params) {
    return repository.getMovieCredits(movieId: params.movieId);
  }
}
