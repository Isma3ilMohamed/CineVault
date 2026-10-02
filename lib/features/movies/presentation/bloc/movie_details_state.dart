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
  final Movie movie;
  final List<Movie> similarMovies;
  final List<CastMember> cast;

  final Video? trailer;

  const MovieDetailsLoaded({
    required this.movie,
    required this.similarMovies,
    required this.cast,
    this.trailer,
  });

  @override
  List<Object?> get props => [movie, similarMovies, cast, trailer];
}

final class MovieDetailsError extends MovieDetailsState {
  final String message;

  const MovieDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
