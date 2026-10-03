import 'package:bloc/bloc.dart';
import 'package:core_base/core_base.dart';
import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_details/src/movie_details_contract.dart';

@injectable
class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState>
    with EventGuard<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc({
    @factoryParam required this.movieId,
    required this.getMovieDetails,
    required this.getSimilarMovies,
    required this.getMovieCredits,
    required this.getMovieTrailer,
    required this.getGenres,
  }) : super(const MovieDetailsState.initial()) {
    on<MovieDetailsStarted>((_, emit) => _load(emit));
    on<MovieDetailsRetried>((_, emit) => _load(emit));
  }

  final int movieId;
  final GetMovieDetails getMovieDetails;
  final GetSimilarMovies getSimilarMovies;
  final GetMovieCredits getMovieCredits;
  final GetMovieTrailer getMovieTrailer;
  final GetGenres getGenres;

  /// Start once from the initial state; retry only from the error state (so a
  /// double tap on Retry, or a stray Started, cannot trigger a second load).
  @override
  bool isEventAllowed(MovieDetailsEvent event, MovieDetailsState state) => switch ((state, event)) {
    (MovieDetailsInitial(), MovieDetailsStarted()) => true,
    (MovieDetailsError(), MovieDetailsRetried()) => true,
    _ => false,
  };

  /// Only the details request is critical; similar movies, cast, trailer and
  /// genres fall back to empty/null on failure.
  Future<void> _load(Emitter<MovieDetailsState> emit) async {
    emit(const MovieDetailsState.loading());

    final params = MovieIdParams(movieId: movieId);
    final (details, similar, cast, trailer, genres) = await (
      getMovieDetails(params),
      getSimilarMovies(SimilarMoviesParams(movieId: movieId)),
      getMovieCredits(params),
      getMovieTrailer(params),
      getGenres(const NoParams()),
    ).wait;

    switch (details) {
      case Err(:final failure):
        emit(MovieDetailsState.error(failure));
      case Ok(value: final movie):
        final genreNames = {for (final g in genres.getOrElse(() => const [])) g.id: g.name};
        emit(
          MovieDetailsState.loaded(
            movie: movie,
            similarMovies: similar.getOrElse(() => const []),
            cast: cast.getOrElse(() => const []),
            genres: movie.genreIds.map((id) => genreNames[id]).nonNulls.toList(),
            trailer: trailer.valueOrNull,
          ),
        );
    }
  }
}
