import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'fixtures.dart';

class _MockGetMoviesByCategory extends Mock implements GetMoviesByCategory {}

void main() {
  late _MockGetMoviesByCategory getMovies;

  setUpAll(
    () => registerFallbackValue(const MoviesByCategoryParams(category: MovieCategory.popular)),
  );

  setUp(() => getMovies = _MockGetMoviesByCategory());

  MovieListBloc build() =>
      MovieListBloc(category: MovieCategory.topRated, getMoviesByCategory: getMovies);

  void stubPage(int page, Result<List<Movie>> result) =>
      when(() => getMovies(MoviesByCategoryParams(category: MovieCategory.topRated, page: page)))
          .thenAnswer((_) async => result);

  blocTest<MovieListBloc, MovieListState>(
    'started loads the first page of its category',
    setUp: () => stubPage(1, Ok([movie(1)])),
    build: build,
    act: (bloc) => bloc.add(const MovieListEvent.started()),
    expect: () => [
      const MovieListState.loading(),
      MovieListState.loaded(movies: [movie(1)], page: 1, hasReachedMax: false),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'a failed first page keeps the failure in the state',
    setUp: () => stubPage(1, const Err(NetworkFailure())),
    build: build,
    act: (bloc) => bloc.add(const MovieListEvent.started()),
    expect: () => [const MovieListState.loading(), const MovieListState.error(NetworkFailure())],
  );

  blocTest<MovieListBloc, MovieListState>(
    'load more appends the next page; an empty page marks the end',
    setUp: () {
      stubPage(2, Ok([movie(2)]));
      stubPage(3, const Ok([]));
    },
    build: build,
    seed: () => MovieListState.loaded(movies: [movie(1)], page: 1, hasReachedMax: false),
    act: (bloc) async {
      bloc.add(const MovieListEvent.loadMoreRequested());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const MovieListEvent.loadMoreRequested());
    },
    skip: 1,
    expect: () => [
      MovieListState.loaded(movies: [movie(1), movie(2)], page: 2, hasReachedMax: false),
      MovieListState.loaded(
        movies: [movie(1), movie(2)],
        page: 2,
        hasReachedMax: false,
        isLoadingMore: true,
      ),
      MovieListState.loaded(movies: [movie(1), movie(2)], page: 3, hasReachedMax: true),
    ],
  );

  test('extra load-more requests while a page is loading are dropped', () async {
    final page2 = Completer<Result<List<Movie>>>();
    when(() => getMovies(const MoviesByCategoryParams(category: MovieCategory.topRated, page: 2)))
        .thenAnswer((_) => page2.future);
    final bloc = build()
      ..emit(MovieListState.loaded(movies: [movie(1)], page: 1, hasReachedMax: false))
      ..add(const MovieListEvent.loadMoreRequested())
      ..add(const MovieListEvent.loadMoreRequested());
    await Future<void>.delayed(Duration.zero);

    page2.complete(Ok([movie(2)]));
    await Future<void>.delayed(Duration.zero);

    verify(() => getMovies(any())).called(1);
    expect(bloc.state, isA<MovieListLoaded>().having((s) => s.page, 'page', 2));
    await bloc.close();
  });

  blocTest<MovieListBloc, MovieListState>(
    'a failed next page only stops the spinner',
    setUp: () => stubPage(2, const Err(NetworkFailure())),
    build: build,
    seed: () => MovieListState.loaded(movies: [movie(1)], page: 1, hasReachedMax: false),
    act: (bloc) => bloc.add(const MovieListEvent.loadMoreRequested()),
    expect: () => [
      MovieListState.loaded(movies: [movie(1)], page: 1, hasReachedMax: false, isLoadingMore: true),
      MovieListState.loaded(movies: [movie(1)], page: 1, hasReachedMax: false),
    ],
  );
}
