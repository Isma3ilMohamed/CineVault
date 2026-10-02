import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/core/usecase/usecase.dart';
import 'package:cine_vault/features/movies/domain/entities/video.dart';
import 'package:cine_vault/features/movies/domain/repositories/movie_repository.dart';
import 'package:cine_vault/features/movies/domain/usecases/get_movie_details.dart';

class GetMovieVideos implements UseCase<List<Video>, MovieIdParams> {
  const GetMovieVideos(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<List<Video>>> call(MovieIdParams params) {
    return repository.getMovieVideos(movieId: params.movieId);
  }
}
