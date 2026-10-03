import 'package:core_result/core_result.dart';
import 'package:domain/src/movies/entities/cast_member.dart';
import 'package:domain/src/movies/movie_repository.dart';
import 'package:domain/src/movies/usecases/get_movie_details.dart';
import 'package:domain/src/usecase.dart';

class GetMovieCredits implements UseCase<List<CastMember>, MovieIdParams> {
  const GetMovieCredits(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<CastMember>>> call(MovieIdParams params) {
    return repository.getMovieCredits(movieId: params.movieId);
  }
}
