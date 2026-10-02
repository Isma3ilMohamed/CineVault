import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cast_member.dart';
import '../repositories/movie_repository.dart';
import 'get_movie_details.dart';

/// ببساطة كدا: بيجيب الـ cast بتاع فيلم معين
/// بنـ reuse MovieIdParams من get_movie_details
class GetMovieCredits implements UseCase<List<CastMember>, MovieIdParams> {
  final MovieRepository repository;

  const GetMovieCredits(this.repository);

  @override
  Future<Result<List<CastMember>>> call(MovieIdParams params) {
    return repository.getMovieCredits(movieId: params.movieId);
  }
}
