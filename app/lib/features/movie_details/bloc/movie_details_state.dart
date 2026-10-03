part of 'movie_details_bloc.dart';

@freezed
sealed class MovieDetailsState with _$MovieDetailsState {
  const factory MovieDetailsState.initial() = MovieDetailsInitial;

  const factory MovieDetailsState.loading() = MovieDetailsLoading;

  const factory MovieDetailsState.loaded({
    required Movie movie,
    required List<Movie> similarMovies,
    required List<CastMember> cast,

    /// Genre names for `movie.genreIds`; empty when genres failed to load.
    required List<String> genres,
    Video? trailer,
  }) = MovieDetailsLoaded;

  const factory MovieDetailsState.error(Failure failure) = MovieDetailsError;
}
