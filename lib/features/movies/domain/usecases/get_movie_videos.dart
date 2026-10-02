import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/video.dart';
import '../repositories/movie_repository.dart';
import 'get_movie_details.dart';

class GetMovieVideos implements UseCase<List<Video>, MovieIdParams> {
  final MovieRepository repository;

  const GetMovieVideos(this.repository);

  @override
  Future<Result<List<Video>>> call(MovieIdParams params) {
    return repository.getMovieVideos(movieId: params.movieId);
  }
}
