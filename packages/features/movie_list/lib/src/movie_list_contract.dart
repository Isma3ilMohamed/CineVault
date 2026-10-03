import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_list_contract.freezed.dart';

@freezed
sealed class MovieListState with _$MovieListState {
  const factory MovieListState.initial() = MovieListInitial;

  const factory MovieListState.loading() = MovieListLoading;

  const factory MovieListState.loaded({
    required List<Movie> movies,
    required int page,
    required bool hasReachedMax,
    @Default(false) bool isLoadingMore,
  }) = MovieListLoaded;

  const factory MovieListState.error(Failure failure) = MovieListError;
}

@freezed
sealed class MovieListEvent with _$MovieListEvent {
  /// Sent once by the Route when the bloc is created.
  const factory MovieListEvent.started() = MovieListStarted;

  /// Retry from the error state.
  const factory MovieListEvent.retried() = MovieListRetried;

  /// The user scrolled near the end of the list.
  const factory MovieListEvent.loadMoreRequested() = MovieListLoadMoreRequested;
}

// No MovieListEffect: a failed next page just stops the spinner, and the
// user can scroll again to retry it.
