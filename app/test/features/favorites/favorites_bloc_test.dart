import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cine_vault/data/repositories/favorites_repository.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/favorites/bloc/favorites_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'fixtures.dart';

class _MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late _MockFavoritesRepository repository;
  late StreamController<List<Movie>> storage;

  setUp(() {
    repository = _MockFavoritesRepository();
    storage = StreamController<List<Movie>>();
    when(() => repository.watchFavorites()).thenAnswer((_) => storage.stream);
  });

  tearDown(() => storage.close());

  blocTest<FavoritesBloc, FavoritesState>(
    'follows storage after started',
    build: () => FavoritesBloc(favoritesRepository: repository),
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
    final bloc = FavoritesBloc(favoritesRepository: repository)
      ..add(const FavoritesEvent.started());
    await Future<void>.delayed(Duration.zero);
    expect(storage.hasListener, isTrue);

    await bloc.close();
    expect(storage.hasListener, isFalse);
  });
}
