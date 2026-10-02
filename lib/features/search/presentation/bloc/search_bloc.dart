import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/usecases/clear_recent_searches.dart';
import '../../domain/usecases/get_recent_searches.dart';
import '../../domain/usecases/save_recent_search.dart';
import '../../domain/usecases/search_movies.dart';

part 'search_event.dart';
part 'search_state.dart';

/// ببساطة كدا: bloc الـ Search
/// - SearchQueryChanged بيشغل Timer للـ debounce
/// - لما الـ Timer يخلص، بنضيف internal _SearchExecuted event
/// - الـ handler بيعمل emit للـ loading/loaded/empty/error
///
/// ليه Timer بدل rxdart؟ عشان ما نزودش dependency. الـ logic بسيط وواضح.
/// لما نضيف tests، نمرر debounce: Duration.zero.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  static const _debounceDuration = Duration(milliseconds: 400);
  static const _minQueryLength = 2;

  final SearchMovies searchMoviesUseCase;
  final GetRecentSearches getRecentSearchesUseCase;
  final SaveRecentSearch saveRecentSearchUseCase;
  final ClearRecentSearches clearRecentSearchesUseCase;

  Timer? _debounceTimer;

  SearchBloc({
    required this.searchMoviesUseCase,
    required this.getRecentSearchesUseCase,
    required this.saveRecentSearchUseCase,
    required this.clearRecentSearchesUseCase,
  }) : super(const SearchIdle()) {
    on<SearchStarted>(_onStarted);
    on<SearchQueryChanged>(_onQueryChanged);
    on<_SearchExecuted>(_onSearchExecuted);
    on<RecentSearchTapped>(_onRecentSearchTapped);
    on<SearchCleared>(_onCleared);
    on<SearchLoadMore>(_onLoadMore);
    on<SearchRetried>(_onRetried);
    on<RecentSearchesCleared>(_onRecentSearchesCleared);
  }

  Future<void> _onStarted(
    SearchStarted event,
    Emitter<SearchState> emit,
  ) async {
    await _emitIdleWithRecents(emit);
  }

  void _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) {
    _debounceTimer?.cancel();

    final trimmed = event.query.trim();
    if (trimmed.length < _minQueryLength) {
      // Empty أو قصير → نرجع لـ idle (recents). الـ cancel فوق كفاية.
      add(const SearchCleared());
      return;
    }

    _debounceTimer = Timer(_debounceDuration, () {
      add(_SearchExecuted(trimmed));
    });
  }

  Future<void> _onSearchExecuted(
    _SearchExecuted event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading(query: event.query));

    final result = await searchMoviesUseCase(
      SearchParams(query: event.query, page: 1),
    );

    switch (result) {
      case Err(:final failure):
        emit(SearchError(query: event.query, message: failure.message));
      case Ok(:final value):
        if (value.isEmpty) {
          emit(SearchEmpty(query: event.query));
        } else {
          emit(SearchLoaded(
            query: event.query,
            results: value,
            page: 1,
            hasReachedMax: false,
          ));
        }
        // نحفظ كـ recent — silent failure لو الـ local store فشل
        await saveRecentSearchUseCase(
          SaveRecentSearchParams(query: event.query),
        );
    }
  }

  Future<void> _onRecentSearchTapped(
    RecentSearchTapped event,
    Emitter<SearchState> emit,
  ) async {
    _debounceTimer?.cancel();
    // نشغل البحث مباشرة من غير debounce
    add(_SearchExecuted(event.query.trim()));
  }

  Future<void> _onCleared(
    SearchCleared event,
    Emitter<SearchState> emit,
  ) async {
    _debounceTimer?.cancel();
    await _emitIdleWithRecents(emit);
  }

  Future<void> _onLoadMore(
    SearchLoadMore event,
    Emitter<SearchState> emit,
  ) async {
    final current = state;
    if (current is! SearchLoaded) return;
    if (current.hasReachedMax || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = current.page + 1;
    final result = await searchMoviesUseCase(
      SearchParams(query: current.query, page: nextPage),
    );

    switch (result) {
      case Err():
        emit(current.copyWith(isLoadingMore: false));
      case Ok(:final value):
        emit(current.copyWith(
          results: [...current.results, ...value],
          page: nextPage,
          hasReachedMax: value.isEmpty,
          isLoadingMore: false,
        ));
    }
  }

  Future<void> _onRetried(
    SearchRetried event,
    Emitter<SearchState> emit,
  ) async {
    final current = state;
    final query = switch (current) {
      SearchError(:final query) => query,
      SearchEmpty(:final query) => query,
      SearchLoaded(:final query) => query,
      SearchLoading(:final query) => query,
      SearchIdle() => '',
    };
    if (query.isEmpty) return;
    add(_SearchExecuted(query));
  }

  Future<void> _onRecentSearchesCleared(
    RecentSearchesCleared event,
    Emitter<SearchState> emit,
  ) async {
    await clearRecentSearchesUseCase(const NoParams());
    if (state is SearchIdle) {
      emit(const SearchIdle(recentSearches: []));
    }
  }

  Future<void> _emitIdleWithRecents(Emitter<SearchState> emit) async {
    final result = await getRecentSearchesUseCase(const NoParams());
    final recents = result.getOrElse(() => const <String>[]);
    emit(SearchIdle(recentSearches: recents));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
