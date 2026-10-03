import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cine_vault/features/favorites/favorites_bloc.dart';
import 'package:cine_vault/features/favorites/favorites_contract.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'fixtures.dart';

class _MockWatchFavorites extends Mock implements WatchFavorites {}

void main() {
  late _MockWatchFavorites watchFavorites;
  late StreamController<List<Movie>> storage;

  setUp(() {
    watchFavorites = _MockWatchFavorites();
    storage = StreamController<List<Movie>>();
    when(() => watchFavorites()).thenAnswer((_) => storage.stream);
  });

  tearDown(() => storage.close());

  blocTest<FavoritesBloc, FavoritesState>(
    'follows storage after started',
    build: () => FavoritesBloc(watchFavorites: watchFavorites),
    act: (bloc) async {
      bloc.add(const FavoritesEvent.started());
      await Future<void>.delayed(Duration.zero);
      storage
        ..add(const [])
        ..add([movie(1)]);
    },
    expect: () => [
      const FavoritesState.loaded([]),
      FavoritesState.loaded([movie(1)]),
    ],
  );

  test('closing the bloc cancels the storage subscription', () async {
    final bloc = FavoritesBloc(watchFavorites: watchFavorites)..add(const FavoritesEvent.started());
    await Future<void>.delayed(Duration.zero);
    expect(storage.hasListener, isTrue);

    await bloc.close();
    expect(storage.hasListener, isFalse);
  });

  test('EventGuard rejects a second started', () async {
    final bloc = FavoritesBloc(watchFavorites: watchFavorites)..add(const FavoritesEvent.started());
    await Future<void>.delayed(Duration.zero);
    storage.add(const []);
    await Future<void>.delayed(Duration.zero);

    expect(() => bloc.add(const FavoritesEvent.started()), throwsA(isA<AssertionError>()));
    await bloc.close();
  });
}
