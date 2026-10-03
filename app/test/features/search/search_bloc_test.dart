import 'dart:async';

import 'package:cine_vault/features/search/bloc/search_bloc.dart';
import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'fixtures.dart';

class _MockSearchMovies extends Mock implements SearchMovies {}

class _MockGetRecentSearches extends Mock implements GetRecentSearches {}

class _MockSaveRecentSearch extends Mock implements SaveRecentSearch {}

class _MockClearRecentSearches extends Mock implements ClearRecentSearches {}

void main() {
  late _MockSearchMovies searchMovies;
  late _MockGetRecentSearches getRecentSearches;
  late _MockSaveRecentSearch saveRecentSearch;
  late SearchBloc bloc;

  setUpAll(() {
    registerFallbackValue(const SearchParams(query: ''));
    registerFallbackValue(const SaveRecentSearchParams(query: ''));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    searchMovies = _MockSearchMovies();
    getRecentSearches = _MockGetRecentSearches();
    saveRecentSearch = _MockSaveRecentSearch();

    when(() => getRecentSearches(any())).thenAnswer((_) async => const Ok(['batman']));
    when(() => saveRecentSearch(any())).thenAnswer((_) async => const Ok(null));

    bloc = SearchBloc(
      searchMovies: searchMovies,
      getRecentSearches: getRecentSearches,
      saveRecentSearch: saveRecentSearch,
      clearRecentSearches: _MockClearRecentSearches(),
      debounce: Duration.zero,
    );
  });

  tearDown(() => bloc.close());

  /// Lets timers, event queues and pending futures run.
  Future<void> pump() => Future<void>.delayed(const Duration(milliseconds: 10));

  test('started shows the recent searches', () async {
    bloc.add(const SearchEvent.started());
    await pump();
    expect(bloc.state, const SearchState.idle(recentSearches: ['batman']));
  });

  test('a slow response for an old query never overwrites newer results', () async {
    final slowBatman = Completer<Result<List<Movie>>>();
    final fastSuperman = Completer<Result<List<Movie>>>();
    when(() => searchMovies(const SearchParams(query: 'batman')))
        .thenAnswer((_) => slowBatman.future);
    when(() => searchMovies(const SearchParams(query: 'superman')))
        .thenAnswer((_) => fastSuperman.future);

    final states = <SearchState>[];
    final sub = bloc.stream.listen(states.add);

    bloc.add(const SearchEvent.queryChanged('batman'));
    await pump();
    bloc.add(const SearchEvent.queryChanged('superman'));
    await pump();

    fastSuperman.complete(Ok([movie(2)]));
    await pump();
    slowBatman.complete(Ok([movie(1)]));
    await pump();

    expect(bloc.state, isA<SearchLoaded>().having((s) => s.query, 'query', 'superman'));
    expect(states.whereType<SearchLoaded>().map((s) => s.query), isNot(contains('batman')));
    await sub.cancel();
  });

  test('clearing while a search is in flight stays idle', () async {
    final pending = Completer<Result<List<Movie>>>();
    when(() => searchMovies(any())).thenAnswer((_) => pending.future);

    bloc.add(const SearchEvent.queryChanged('batman'));
    await pump();
    expect(bloc.state, isA<SearchLoading>());

    bloc.add(const SearchEvent.cleared());
    await pump();
    pending.complete(Ok([movie(1)]));
    await pump();

    expect(bloc.state, isA<SearchIdle>());
  });

  test('load more finishing after a new search does not restore old results', () async {
    final page2 = Completer<Result<List<Movie>>>();
    when(() => searchMovies(const SearchParams(query: 'batman')))
        .thenAnswer((_) async => Ok([movie(1)]));
    when(() => searchMovies(const SearchParams(query: 'batman', page: 2)))
        .thenAnswer((_) => page2.future);
    when(() => searchMovies(const SearchParams(query: 'superman')))
        .thenAnswer((_) async => Ok([movie(2)]));

    bloc.add(const SearchEvent.queryChanged('batman'));
    await pump();
    bloc.add(const SearchEvent.loadMoreRequested());
    await pump();
    bloc.add(const SearchEvent.queryChanged('superman'));
    await pump();
    page2.complete(Ok([movie(3)]));
    await pump();

    expect(bloc.state, isA<SearchLoaded>().having((s) => s.query, 'query', 'superman'));
  });

  test('a failed search keeps the query and failure, and retry runs it again', () async {
    var calls = 0;
    when(() => searchMovies(const SearchParams(query: 'batman')))
        .thenAnswer((_) async => calls++ == 0 ? const Err(NetworkFailure()) : Ok([movie(1)]));

    bloc.add(const SearchEvent.queryChanged('batman'));
    await pump();
    expect(bloc.state, const SearchState.error(query: 'batman', failure: NetworkFailure()));

    bloc.add(const SearchEvent.retried());
    await pump();
    expect(bloc.state, isA<SearchLoaded>());
  });

  test('retry outside the error state does nothing', () async {
    bloc.add(const SearchEvent.retried());
    await pump();
    verifyNever(() => searchMovies(any()));
  });
}
