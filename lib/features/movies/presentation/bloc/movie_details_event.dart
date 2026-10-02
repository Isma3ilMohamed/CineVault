part of 'movie_details_bloc.dart';

sealed class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadMovieDetails extends MovieDetailsEvent {
  final int movieId;

  const LoadMovieDetails(this.movieId);

  @override
  List<Object> get props => [movieId];
}

final class RetryMovieDetails extends MovieDetailsEvent {
  final int movieId;

  const RetryMovieDetails(this.movieId);

  @override
  List<Object> get props => [movieId];
}
