import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core_base/core_base.dart';
import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:search/src/search_contract.dart';

/// Every way of starting a search (typing, tapping a recent, retrying,
/// clearing) funnels into one [SearchRequested] event handled with
/// `restartable()`. A newer request cancels the one in flight, so a slow
/// response for an old query can never overwrite newer results.
///
/// Typing is debounced with a cancellable [Timer] before it becomes a request.
class SearchBloc extends Bloc<SearchEvent, SearchState> with EventGuard<SearchEvent, SearchState> {
  SearchBloc({
    required this.searchMovies,
    required this.getRecentSearches,
    required this.saveRecentSearch,
    required this.clearRecentSearches,
    this._debounce = _defaultDebounce,
  }) : super(const SearchState.idle()) {
    on<SearchStarted>((_, emit) => _emitIdleWithRecents(emit));
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchRequested>(_onRequested, transformer: restartable());
    on<RecentSearchTapped>((event, _) => _request(event.query.trim()));
    on<SearchCleared>((_, _) => _request(''));
    on<SearchLoadMoreRequested>(_onLoadMore);
    on<SearchRetried>((_, _) {
      if (state case SearchError(:final query)) _request(query);
    });
    on<RecentSearchesCleared>(_onRecentSearchesCleared);
  }

  static const _defaultDebounce = Duration(milliseconds: 400);
  static const _minQueryLength = 2;

  final SearchMovies searchMovies;
  final GetRecentSearches getRecentSearches;
  final SaveRecentSearch saveRecentSearch;
  final ClearRecentSearches clearRecentSearches;
  final Duration _debounce;

  Timer? _debounceTimer;

  /// Taps that only make sense on the screen that shows them. Load more is
  /// allowed in any results state: the grid keeps reporting scrolls until it
  /// rebuilds, and [_onLoadMore] drops the extras.
  @override
  bool isEventAllowed(SearchEvent event, SearchState state) => switch ((state, event)) {
    (SearchIdle(), SearchStarted()) => true,
    (_, SearchStarted()) => false,
    (SearchIdle(), RecentSearchTapped() || RecentSearchesCleared()) => true,
    (_, RecentSearchTapped() || RecentSearchesCleared()) => false,
    (SearchError(), SearchRetried()) => true,
    (_, SearchRetried()) => false,
    _ => true,
  };

  void _request(String query) {
    _debounceTimer?.cancel();
    add(SearchEvent.requested(query));
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    final trimmed = event.query.trim();
    if (trimmed.length < _minQueryLength) {
      // Too short: back to idle right away (also cancels any search in flight).
      _request('');
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () => add(SearchEvent.requested(trimmed)));
  }

  Future<void> _onRequested(SearchRequested event, Emitter<SearchState> emit) async {
    final query = event.query;
    if (query.isEmpty) {
      await _emitIdleWithRecents(emit);
      return;
    }

    emit(SearchState.loading(query: query));
    final result = await searchMovies(SearchParams(query: query));

    // Cancelled by a newer request while awaiting: drop the stale result.
    if (emit.isDone) return;

    switch (result) {
      case Err(:final failure):
        emit(SearchState.error(query: query, failure: failure));
      case Ok(value: final movies):
        emit(
          movies.isEmpty
              ? SearchState.empty(query: query)
              : SearchState.loaded(query: query, results: movies, page: 1, hasReachedMax: false),
        );
        // Saving a recent is best-effort; a local storage failure is ignored.
        await saveRecentSearch(SaveRecentSearchParams(query: query));
    }
  }

  Future<void> _onLoadMore(SearchLoadMoreRequested event, Emitter<SearchState> emit) async {
    final current = state;
    if (current is! SearchLoaded || current.hasReachedMax || current.isLoadingMore) return;

    final loading = current.copyWith(isLoadingMore: true);
    emit(loading);

    final nextPage = current.page + 1;
    final result = await searchMovies(SearchParams(query: current.query, page: nextPage));

    // A new search (or clear) happened while loading: don't resurrect old results.
    if (!identical(state, loading)) return;

    switch (result) {
      case Err():
        emit(current);
      case Ok(value: final movies):
        emit(
          current.copyWith(
            results: [...current.results, ...movies],
            page: nextPage,
            hasReachedMax: movies.isEmpty,
          ),
        );
    }
  }

  Future<void> _onRecentSearchesCleared(
    RecentSearchesCleared event,
    Emitter<SearchState> emit,
  ) async {
    await clearRecentSearches(const NoParams());
    if (state is SearchIdle) emit(const SearchState.idle());
  }

  Future<void> _emitIdleWithRecents(Emitter<SearchState> emit) async {
    final result = await getRecentSearches(const NoParams());
    if (emit.isDone) return;
    emit(SearchState.idle(recentSearches: result.getOrElse(() => const <String>[])));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
