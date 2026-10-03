part of 'movie_details_bloc.dart';

@freezed
sealed class MovieDetailsEvent with _$MovieDetailsEvent {
  /// Sent once by the page when the bloc is created.
  const factory MovieDetailsEvent.started() = MovieDetailsStarted;

  /// Retry from the error state.
  const factory MovieDetailsEvent.retried() = MovieDetailsRetried;
}
