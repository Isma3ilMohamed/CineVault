import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

/// Search screen bloc.
///
/// Every way of starting a search (typing, tapping a recent, retrying,
/// clearing) funnels into one internal [_SearchRequested] event handled with
/// `restartable()`. A newer request cancels the one in flight, so a slow
/// response for an old query can never overwrite newer results.
///
/// Typing is debounced with a cancellable [Timer] before it becomes a request.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required this.searchMoviesUseCase,
    required this.getRecentSearchesUseCase,
    required this.saveRecentSearchUseCase,
    required this.clearRecentSearchesUseCase,
    this._debounce = _defaultDebounce,
  }) : super(const SearchIdle()) {
    on<SearchStarted>(_onStarted);
    on<SearchQueryChanged>(_onQueryChanged);
    on<_SearchRequested>(_onSearchRequested, transformer: restartable());
    on<RecentSearchTapped>(_onRecentSearchTapped);
    on<SearchCleared>(_onCleared);
    on<SearchLoadMore>(_onLoadMore);
    on<SearchRetried>(_onRetried);
    on<RecentSearchesCleared>(_onRecentSearchesCleared);
  }
  static const _defaultDebounce = Duration(milliseconds: 400);
  static const _minQueryLength = 2;

  final SearchMovies searchMoviesUseCase;
  final GetRecentSearches getRecentSearchesUseCase;
  final SaveRecentSearch saveRecentSearchUseCase;
  final ClearRecentSearches clearRecentSearchesUseCase;
  final Duration _debounce;

  Timer? _debounceTimer;

  Future<void> _onStarted(SearchStarted event, Emitter<SearchState> emit) async {
    await _emitIdleWithRecents(emit);
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();

    final trimmed = event.query.trim();
    if (trimmed.length < _minQueryLength) {
      // Too short: back to idle right away (also cancels any search in flight).
      add(const _SearchRequested(''));
      return;
    }

    _debounceTimer = Timer(_debounce, () => add(_SearchRequested(trimmed)));
  }

  Future<void> _onSearchRequested(_SearchRequested event, Emitter<SearchState> emit) async {
    final query = event.query;
    if (query.isEmpty) {
      await _emitIdleWithRecents(emit);
      return;
    }

    emit(SearchLoading(query: query));

    final result = await searchMoviesUseCase(SearchParams(query: query));

    // Cancelled by a newer request while awaiting: drop the stale result.
    if (emit.isDone) return;

    switch (result) {
      case Err(:final failure):
        emit(SearchError(query: query, message: failure.message));
      case Ok(:final value):
        if (value.isEmpty) {
          emit(SearchEmpty(query: query));
        } else {
          emit(SearchLoaded(query: query, results: value, page: 1, hasReachedMax: false));
        }
        // Saving a recent is best-effort; a local storage failure is ignored.
        await saveRecentSearchUseCase(SaveRecentSearchParams(query: query));
    }
  }

  void _onRecentSearchTapped(RecentSearchTapped event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();
    add(_SearchRequested(event.query.trim()));
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();
    add(const _SearchRequested(''));
  }

  Future<void> _onLoadMore(SearchLoadMore event, Emitter<SearchState> emit) async {
    final current = state;
    if (current is! SearchLoaded) return;
    if (current.hasReachedMax || current.isLoadingMore) return;

    final loading = current.copyWith(isLoadingMore: true);
    emit(loading);

    final nextPage = current.page + 1;
    final result = await searchMoviesUseCase(SearchParams(query: current.query, page: nextPage));

    // A new search (or clear) happened while loading: don't resurrect old results.
    if (!identical(state, loading)) return;

    switch (result) {
      case Err():
        emit(current.copyWith(isLoadingMore: false));
      case Ok(:final value):
        emit(
          current.copyWith(
            results: [...current.results, ...value],
            page: nextPage,
            hasReachedMax: value.isEmpty,
            isLoadingMore: false,
          ),
        );
    }
  }

  void _onRetried(SearchRetried event, Emitter<SearchState> emit) {
    final query = switch (state) {
      SearchError(:final query) => query,
      SearchEmpty(:final query) => query,
      SearchLoaded(:final query) => query,
      SearchLoading(:final query) => query,
      SearchIdle() => '',
    };
    if (query.isEmpty) return;
    add(_SearchRequested(query));
  }

  Future<void> _onRecentSearchesCleared(
    RecentSearchesCleared event,
    Emitter<SearchState> emit,
  ) async {
    await clearRecentSearchesUseCase(const NoParams());
    if (state is SearchIdle) {
      emit(const SearchIdle());
    }
  }

  Future<void> _emitIdleWithRecents(Emitter<SearchState> emit) async {
    final result = await getRecentSearchesUseCase(const NoParams());
    if (emit.isDone) return;
    final recents = result.getOrElse(() => const <String>[]);
    emit(SearchIdle(recentSearches: recents));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
