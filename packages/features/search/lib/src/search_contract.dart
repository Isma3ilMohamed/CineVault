import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_contract.freezed.dart';

@freezed
sealed class SearchState with _$SearchState {
  /// No query: shows the recent searches.
  const factory SearchState.idle({@Default(<String>[]) List<String> recentSearches}) = SearchIdle;

  const factory SearchState.loading({required String query}) = SearchLoading;

  const factory SearchState.loaded({
    required String query,
    required List<Movie> results,
    required int page,
    required bool hasReachedMax,
    @Default(false) bool isLoadingMore,
  }) = SearchLoaded;

  const factory SearchState.empty({required String query}) = SearchEmpty;

  const factory SearchState.error({required String query, required Failure failure}) = SearchError;
}

@freezed
sealed class SearchEvent with _$SearchEvent {
  /// Sent once by the Route: loads the recent searches.
  const factory SearchEvent.started() = SearchStarted;

  /// Every keystroke. Debounced by the bloc before it becomes a request.
  const factory SearchEvent.queryChanged(String query) = SearchQueryChanged;

  const factory SearchEvent.recentSearchTapped(String query) = RecentSearchTapped;

  /// The clear (x) button in the search field.
  const factory SearchEvent.cleared() = SearchCleared;

  const factory SearchEvent.loadMoreRequested() = SearchLoadMoreRequested;

  const factory SearchEvent.retried() = SearchRetried;

  const factory SearchEvent.recentSearchesCleared() = RecentSearchesCleared;

  /// Internal: sent by the bloc itself, never by the UI. The single entry
  /// point for running a search; an empty [query] means "back to idle".
  const factory SearchEvent.requested(String query) = SearchRequested;
}

// No SearchEffect: everything the screen shows is state, taps are navigation.
