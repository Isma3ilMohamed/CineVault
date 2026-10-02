part of 'movie_details_bloc.dart';

sealed class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object?> get props => [];
}

final class MovieDetailsInitial extends MovieDetailsState {
  const MovieDetailsInitial();
}

final class MovieDetailsLoading extends MovieDetailsState {
  const MovieDetailsLoading();
}

final class MovieDetailsLoaded extends MovieDetailsState {
  const MovieDetailsLoaded({
    required this.movie,
    required this.similarMovies,
    required this.cast,
    this.trailer,
  });
  final Movie movie;
  final List<Movie> similarMovies;
  final List<CastMember> cast;

  final Video? trailer;

  @override
  List<Object?> get props => [movie, similarMovies, cast, trailer];
}

final class MovieDetailsError extends MovieDetailsState {
  const MovieDetailsError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
