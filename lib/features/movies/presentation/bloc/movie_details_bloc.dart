import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/features/movies/domain/entities/cast_member.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:cine_vault/features/movies/domain/entities/video.dart';
import 'package:cine_vault/features/movies/domain/usecases/get_movie_credits.dart';
import 'package:cine_vault/features/movies/domain/usecases/get_movie_details.dart';
import 'package:cine_vault/features/movies/domain/usecases/get_movie_videos.dart';
import 'package:cine_vault/features/movies/domain/usecases/get_similar_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc({
    required this.getMovieDetails,
    required this.getSimilarMovies,
    required this.getMovieCredits,
    required this.getMovieVideos,
  }) : super(const MovieDetailsInitial()) {
    on<LoadMovieDetails>(_onLoad);
    on<RetryMovieDetails>((event, emit) => _load(event.movieId, emit));
  }
  final GetMovieDetails getMovieDetails;
  final GetSimilarMovies getSimilarMovies;
  final GetMovieCredits getMovieCredits;
  final GetMovieVideos getMovieVideos;

  Future<void> _onLoad(LoadMovieDetails event, Emitter<MovieDetailsState> emit) =>
      _load(event.movieId, emit);

  /// Only the details request is critical; similar, cast and videos fall back
  /// to empty lists on failure.
  Future<void> _load(int movieId, Emitter<MovieDetailsState> emit) async {
    emit(const MovieDetailsLoading());

    final detailsFuture = getMovieDetails(MovieIdParams(movieId: movieId));
    final similarFuture = getSimilarMovies(SimilarMoviesParams(movieId: movieId));
    final creditsFuture = getMovieCredits(MovieIdParams(movieId: movieId));
    final videosFuture = getMovieVideos(MovieIdParams(movieId: movieId));

    final detailsResult = await detailsFuture;
    final similarResult = await similarFuture;
    final creditsResult = await creditsFuture;
    final videosResult = await videosFuture;

    switch (detailsResult) {
      case Err(:final failure):
        emit(MovieDetailsError(message: failure.message));
      case Ok(:final value):
        final similar = similarResult.getOrElse(() => const <Movie>[]);
        final cast = creditsResult.getOrElse(() => const <CastMember>[]);
        final videos = videosResult.getOrElse(() => const <Video>[]);
        // Prefer an official YouTube trailer, then any YouTube trailer, then any YouTube video.
        final trailer = videos.firstWhere(
          (v) => v.isYouTube && v.isTrailer && v.official,
          orElse: () => videos.firstWhere(
            (v) => v.isYouTube && v.isTrailer,
            orElse: () => videos.firstWhere(
              (v) => v.isYouTube,
              orElse: () =>
                  const Video(id: '', key: '', site: '', name: '', type: '', official: false),
            ),
          ),
        );
        emit(
          MovieDetailsLoaded(
            movie: value,
            similarMovies: similar,
            cast: cast,
            trailer: trailer.key.isEmpty ? null : trailer,
          ),
        );
    }
  }
}
