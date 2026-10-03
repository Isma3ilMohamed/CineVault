import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/movie_repository.dart';
import 'package:cine_vault/domain/models/video.dart';
import 'package:cine_vault/domain/usecases/movies/get_movie_details.dart';
import 'package:cine_vault/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

/// The best trailer to play for a movie, or `null` when there is none.
///
/// Only YouTube videos are playable. Preference: an official trailer, then any
/// trailer, then any video.
@lazySingleton
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
