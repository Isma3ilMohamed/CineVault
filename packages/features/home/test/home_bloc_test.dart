import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/src/home_bloc.dart';
import 'package:home/src/home_contract.dart';
import 'package:mocktail/mocktail.dart';

import 'fixtures.dart';

class _MockGetMoviesByCategory extends Mock implements GetMoviesByCategory {}

void main() {
  late _MockGetMoviesByCategory getMovies;

  setUpAll(
    () => registerFallbackValue(const MoviesByCategoryParams(category: MovieCategory.popular)),
  );

  setUp(() => getMovies = _MockGetMoviesByCategory());

  HomeBloc build() => HomeBloc(getMoviesByCategory: getMovies);

  void stubAll(Result<List<Movie>> result) =>
      when(() => getMovies(any())).thenAnswer((_) async => result);

  final sections = {
    for (final category in MovieCategory.values) category: [movie(1)],
  };

  blocTest<HomeBloc, HomeState>(
    'started loads every category',
    setUp: () => stubAll(Ok([movie(1)])),
    build: build,
    act: (bloc) => bloc.add(const HomeEvent.started()),
    expect: () => [const HomeState.loading(), HomeState.loaded(sections: sections)],
    verify: (_) {
      for (final category in MovieCategory.values) {
        verify(() => getMovies(MoviesByCategoryParams(category: category))).called(1);
      }
    },
  );

  blocTest<HomeBloc, HomeState>(
    'one failing category fails the screen with its failure',
    setUp: () {
      stubAll(Ok([movie(1)]));
      when(() => getMovies(const MoviesByCategoryParams(category: MovieCategory.upcoming)))
          .thenAnswer((_) async => const Err(NetworkFailure()));
    },
    build: build,
    act: (bloc) => bloc.add(const HomeEvent.started()),
    expect: () => [const HomeState.loading(), const HomeState.error(NetworkFailure())],
  );

  blocTest<HomeBloc, HomeState>(
    'refresh keeps the sections on screen while it runs',
    setUp: () => stubAll(Ok([movie(2)])),
    build: build,
    seed: () => HomeState.loaded(sections: sections),
    act: (bloc) => bloc.add(const HomeEvent.refreshed()),
    expect: () => [
      HomeState.loaded(sections: sections, isRefreshing: true),
      HomeState.loaded(
        sections: {
          for (final category in MovieCategory.values) category: [movie(2)],
        },
      ),
    ],
  );

  test('a failed refresh keeps the old sections and emits refreshFailed', () async {
    stubAll(const Err(NetworkFailure()));
    final bloc = build()..emit(HomeState.loaded(sections: sections));
    final effects = <HomeEffect>[];
    final sub = bloc.effects.listen(effects.add);

    bloc.add(const HomeEvent.refreshed());
    await bloc.stream.firstWhere((s) => s is HomeLoaded && !s.isRefreshing);
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state, HomeState.loaded(sections: sections));
    expect(effects, [const HomeEffect.refreshFailed(NetworkFailure())]);
    await sub.cancel();
    await bloc.close();
  });

  test('EventGuard rejects a second refresh while one is running', () async {
    final pending = Completer<Result<List<Movie>>>();
    when(() => getMovies(any())).thenAnswer((_) => pending.future);
    final bloc = build()
      ..emit(HomeState.loaded(sections: sections))
      ..add(const HomeEvent.refreshed());
    await Future<void>.delayed(Duration.zero);

    expect(() => bloc.add(const HomeEvent.refreshed()), throwsA(isA<AssertionError>()));
    pending.complete(Ok([movie(1)]));
    await bloc.close();
  });
}
