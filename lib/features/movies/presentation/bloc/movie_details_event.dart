part of 'movie_details_bloc.dart';

sealed class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadMovieDetails extends MovieDetailsEvent {
  const LoadMovieDetails(this.movieId);
  final int movieId;

  @override
  List<Object> get props => [movieId];
}

final class RetryMovieDetails extends MovieDetailsEvent {
  const RetryMovieDetails(this.movieId);
  final int movieId;

  @override
  List<Object> get props => [movieId];
}
