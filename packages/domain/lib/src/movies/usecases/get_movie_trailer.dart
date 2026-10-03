import 'package:core_result/core_result.dart';
import 'package:domain/src/movies/entities/video.dart';
import 'package:domain/src/movies/movie_repository.dart';
import 'package:domain/src/movies/usecases/get_movie_details.dart';
import 'package:domain/src/usecase.dart';

/// The best trailer to play for a movie, or `null` when there is none.
///
/// Only YouTube videos are playable. Preference: an official trailer, then any
/// trailer, then any video.
class GetMovieTrailer implements UseCase<Video?, MovieIdParams> {
  const GetMovieTrailer(this.repository);
  final MovieRepository repository;

  @override
  Future<Result<Video?>> call(MovieIdParams params) async {
    final result = await repository.getMovieVideos(movieId: params.movieId);
    return result.map(pickTrailer);
  }

  static Video? pickTrailer(List<Video> videos) {
    final playable = videos.where((v) => v.isYouTube && v.key.isNotEmpty).toList();
    return playable.where((v) => v.isTrailer && v.official).firstOrNull ??
        playable.where((v) => v.isTrailer).firstOrNull ??
        playable.firstOrNull;
  }
}
