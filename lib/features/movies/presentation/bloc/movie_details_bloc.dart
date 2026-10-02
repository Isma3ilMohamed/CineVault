import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/result.dart';
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/video.dart';
import '../../domain/usecases/get_movie_credits.dart';
import '../../domain/usecases/get_movie_details.dart';
import '../../domain/usecases/get_movie_videos.dart';
import '../../domain/usecases/get_similar_movies.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

/// ببساطة كدا: Bloc خاص بصفحة الـ Details
/// بيجيب تفاصيل الفيلم + الأفلام الشبيهة في parallel
///
/// Flow:
///   UI → LoadMovieDetails(id) → Bloc → [UseCase, UseCase] في parallel
///   Details fail → error state
///   Details ok + Similar fail → loaded state بـ similar فاضية (degraded)
///   Details ok + Similar ok → loaded state كامل
class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetails getMovieDetails;
  final GetSimilarMovies getSimilarMovies;
  final GetMovieCredits getMovieCredits;
  final GetMovieVideos getMovieVideos;

  MovieDetailsBloc({
    required this.getMovieDetails,
    required this.getSimilarMovies,
    required this.getMovieCredits,
    required this.getMovieVideos,
  }) : super(const MovieDetailsInitial()) {
    on<LoadMovieDetails>(_onLoad);
    on<RetryMovieDetails>(
      (event, emit) => _load(event.movieId, emit),
    );
  }

  Future<void> _onLoad(
    LoadMovieDetails event,
    Emitter<MovieDetailsState> emit,
  ) =>
      _load(event.movieId, emit);

  /// بنشغل الـ 4 requests في parallel عشان نوفر وقت
  /// الـ details هو الـ critical path — لو فشل، نعرض error
  /// الـ similar + cast + videos "nice to have" — لو فشلوا نكمل بقوائم فاضية
  Future<void> _load(int movieId, Emitter<MovieDetailsState> emit) async {
    emit(const MovieDetailsLoading());

    final detailsFuture = getMovieDetails(MovieIdParams(movieId: movieId));
    final similarFuture =
        getSimilarMovies(SimilarMoviesParams(movieId: movieId));
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
        // نختار أول YouTube trailer رسمي، أو أول YouTube video عموماً
        final trailer = videos.firstWhere(
          (v) => v.isYouTube && v.isTrailer && v.official,
          orElse: () => videos.firstWhere(
            (v) => v.isYouTube && v.isTrailer,
            orElse: () => videos.firstWhere(
              (v) => v.isYouTube,
              orElse: () => const Video(
                id: '',
                key: '',
                site: '',
                name: '',
                type: '',
                official: false,
              ),
            ),
          ),
        );
        emit(MovieDetailsLoaded(
          movie: value,
          similarMovies: similar,
          cast: cast,
          trailer: trailer.key.isEmpty ? null : trailer,
        ));
    }
  }
}
