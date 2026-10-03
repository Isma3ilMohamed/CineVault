import 'dart:async';

import 'package:cine_vault/features/search/presentation/bloc/search_bloc.dart';
import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSearchMovies extends Mock implements SearchMovies {}

class _MockGetRecentSearches extends Mock implements GetRecentSearches {}

class _MockSaveRecentSearch extends Mock implements SaveRecentSearch {}

class _MockClearRecentSearches extends Mock implements ClearRecentSearches {}

Movie _movie(int id, String title) => Movie(
  id: id,
  title: title,
  overview: '',
  voteAverage: 0,
  voteCount: 0,
  genreIds: const [],
  originalLanguage: 'en',
  popularity: 0,
  adult: false,
);

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

    when(() => getRecentSearches(any())).thenAnswer((_) async => const Ok(<String>[]));
    when(() => saveRecentSearch(any())).thenAnswer((_) async => const Ok(null));

    bloc = SearchBloc(
      searchMoviesUseCase: searchMovies,
      getRecentSearchesUseCase: getRecentSearches,
      saveRecentSearchUseCase: saveRecentSearch,
      clearRecentSearchesUseCase: _MockClearRecentSearches(),
      debounce: Duration.zero,
    );
  });

  tearDown(() => bloc.close());

  /// Lets timers, event queues and pending futures run.
  Future<void> pump() => Future<void>.delayed(const Duration(milliseconds: 10));

  test('a slow response for an old query never overwrites newer results', () async {
    final slowBatman = Completer<Result<List<Movie>>>();
    final fastSuperman = Completer<Result<List<Movie>>>();
    when(() => searchMovies(const SearchParams(query: 'batman')))
        .thenAnswer((_) => slowBatman.future);
    when(() => searchMovies(const SearchParams(query: 'superman')))
        .thenAnswer((_) => fastSuperman.future);

    final states = <SearchState>[];
    final sub = bloc.stream.listen(states.add);

    bloc.add(const SearchQueryChanged('batman'));
    await pump();
    bloc.add(const SearchQueryChanged('superman'));
    await pump();

    fastSuperman.complete(Ok([_movie(2, 'Superman')]));
    await pump();
    slowBatman.complete(Ok([_movie(1, 'Batman')]));
    await pump();

    expect(bloc.state, isA<SearchLoaded>().having((s) => s.query, 'query', 'superman'));
    expect(states.whereType<SearchLoaded>().map((s) => s.query), isNot(contains('batman')));
    await sub.cancel();
  });

  test('clearing while a search is in flight stays idle', () async {
    final pending = Completer<Result<List<Movie>>>();
    when(() => searchMovies(any())).thenAnswer((_) => pending.future);

    bloc.add(const SearchQueryChanged('batman'));
    await pump();
    expect(bloc.state, isA<SearchLoading>());

    bloc.add(const SearchCleared());
    await pump();
    pending.complete(Ok([_movie(1, 'Batman')]));
    await pump();

    expect(bloc.state, isA<SearchIdle>());
  });

  test('load more finishing after a new search does not restore old results', () async {
    final page2 = Completer<Result<List<Movie>>>();
    when(() => searchMovies(const SearchParams(query: 'batman')))
        .thenAnswer((_) async => Ok([_movie(1, 'Batman')]));
    when(() => searchMovies(const SearchParams(query: 'batman', page: 2)))
        .thenAnswer((_) => page2.future);
    when(() => searchMovies(const SearchParams(query: 'superman')))
        .thenAnswer((_) async => Ok([_movie(2, 'Superman')]));

    bloc.add(const SearchQueryChanged('batman'));
    await pump();
    bloc.add(const SearchLoadMore());
    await pump();
    bloc.add(const SearchQueryChanged('superman'));
    await pump();
    page2.complete(Ok([_movie(3, 'Batman Returns')]));
    await pump();

    expect(bloc.state, isA<SearchLoaded>().having((s) => s.query, 'query', 'superman'));
  });
}
