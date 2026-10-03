import 'package:bloc/bloc.dart';
import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/movie_repository.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'movie_details_bloc.freezed.dart';
part 'movie_details_event.dart';
part 'movie_details_state.dart';

@injectable
class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc({@factoryParam required this.movieId, required this.movieRepository})
    : super(const MovieDetailsState.initial()) {
    on<MovieDetailsStarted>((_, emit) => _load(emit));
    on<MovieDetailsRetried>((_, emit) => _load(emit));
  }

  final int movieId;
  final MovieRepository movieRepository;

  /// Only the details request is critical; similar movies, cast, trailer and
  /// genres fall back to empty/null on failure.
  Future<void> _load(Emitter<MovieDetailsState> emit) async {
    emit(const MovieDetailsState.loading());

    final (details, similar, cast, trailer, genres) = await (
      movieRepository.getMovieDetails(movieId: movieId),
      movieRepository.getSimilarMovies(movieId: movieId),
      movieRepository.getMovieCredits(movieId: movieId),
      movieRepository.getMovieTrailer(movieId: movieId),
      movieRepository.getGenres(),
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
