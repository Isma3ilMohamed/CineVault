import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc({
    required this.getMovieDetails,
    required this.getSimilarMovies,
    required this.getMovieCredits,
    required this.getMovieTrailer,
  }) : super(const MovieDetailsInitial()) {
    on<LoadMovieDetails>(_onLoad);
    on<RetryMovieDetails>((event, emit) => _load(event.movieId, emit));
  }
  final GetMovieDetails getMovieDetails;
  final GetSimilarMovies getSimilarMovies;
  final GetMovieCredits getMovieCredits;
  final GetMovieTrailer getMovieTrailer;

  Future<void> _onLoad(LoadMovieDetails event, Emitter<MovieDetailsState> emit) =>
      _load(event.movieId, emit);

  /// Only the details request is critical; similar, cast and the trailer fall
  /// back to empty/null on failure.
  Future<void> _load(int movieId, Emitter<MovieDetailsState> emit) async {
    emit(const MovieDetailsLoading());

    final detailsFuture = getMovieDetails(MovieIdParams(movieId: movieId));
    final similarFuture = getSimilarMovies(SimilarMoviesParams(movieId: movieId));
    final creditsFuture = getMovieCredits(MovieIdParams(movieId: movieId));
    final trailerFuture = getMovieTrailer(MovieIdParams(movieId: movieId));

    final detailsResult = await detailsFuture;
    final similarResult = await similarFuture;
    final creditsResult = await creditsFuture;
    final trailerResult = await trailerFuture;

    switch (detailsResult) {
      case Err(:final failure):
        emit(MovieDetailsError(message: failure.message));
      case Ok(:final value):
        final similar = similarResult.getOrElse(() => const <Movie>[]);
        final cast = creditsResult.getOrElse(() => const <CastMember>[]);
        emit(
          MovieDetailsLoaded(
            movie: value,
            similarMovies: similar,
            cast: cast,
            trailer: trailerResult.valueOrNull,
          ),
        );
    }
  }
}
