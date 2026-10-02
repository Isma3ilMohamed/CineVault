part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

final class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

/// Internal: the single entry point for running a search.
/// An empty [query] means "go back to idle". Handled with `restartable()`,
/// so a newer request cancels the one in flight and stale results never land.
final class _SearchRequested extends SearchEvent {
  final String query;

  const _SearchRequested(this.query);

  @override
  List<Object> get props => [query];
}

final class RecentSearchTapped extends SearchEvent {
  final String query;

  const RecentSearchTapped(this.query);

  @override
  List<Object> get props => [query];
}

final class SearchCleared extends SearchEvent {
  const SearchCleared();
}

final class SearchLoadMore extends SearchEvent {
  const SearchLoadMore();
}

final class SearchRetried extends SearchEvent {
  const SearchRetried();
}

final class RecentSearchesCleared extends SearchEvent {
  const RecentSearchesCleared();
}

final class SearchStarted extends SearchEvent {
  const SearchStarted();
}
