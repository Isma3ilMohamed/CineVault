part of 'search_bloc.dart';

@freezed
sealed class SearchEvent with _$SearchEvent {
  /// Sent once by the page: loads the recent searches.
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
