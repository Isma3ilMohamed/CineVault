part of 'movie_list_bloc.dart';

@freezed
sealed class MovieListEvent with _$MovieListEvent {
  /// Sent once by the page when the bloc is created.
  const factory MovieListEvent.started() = MovieListStarted;

  /// Retry from the error state.
  const factory MovieListEvent.retried() = MovieListRetried;

  /// The user scrolled near the end of the list.
  const factory MovieListEvent.loadMoreRequested() = MovieListLoadMoreRequested;
}
