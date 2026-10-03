import 'package:core_result/core_result.dart';
import 'package:domain/src/movies/entities/video.dart';
import 'package:domain/src/movies/movie_repository.dart';
import 'package:domain/src/movies/usecases/get_movie_details.dart';
import 'package:domain/src/usecase.dart';

class GetMovieVideos implements UseCase<List<Video>, MovieIdParams> {
  const GetMovieVideos(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Video>>> call(MovieIdParams params) {
    return repository.getMovieVideos(movieId: params.movieId);
  }
}
