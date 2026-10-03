import 'dart:async';

import 'package:cine_vault/features/favorites/favorites.dart';
import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'fixtures.dart';

class _MockWatchFavoriteIds extends Mock implements WatchFavoriteIds {}

class _MockToggleFavorite extends Mock implements ToggleFavorite {}

void main() {
  late _MockWatchFavoriteIds watchFavoriteIds;
  late _MockToggleFavorite toggleFavorite;
  late StreamController<Set<int>> storage;

  setUpAll(() => registerFallbackValue(ToggleFavoriteParams(movie: movie(0))));

  setUp(() {
    watchFavoriteIds = _MockWatchFavoriteIds();
    toggleFavorite = _MockToggleFavorite();
    storage = StreamController<Set<int>>();
    when(() => watchFavoriteIds()).thenAnswer((_) => storage.stream);
  });

  tearDown(() => storage.close());

  FavoriteIdsCubit build() =>
      FavoriteIdsCubit(watchFavoriteIds: watchFavoriteIds, toggleFavorite: toggleFavorite);

  test('toggle flips the heart before storage answers', () async {
    final write = Completer<Result<bool>>();
    when(() => toggleFavorite(any())).thenAnswer((_) => write.future);
    final cubit = build();

    unawaited(cubit.toggle(movie(1)));
    expect(cubit.state, {1});

    write.complete(const Ok(true));
    await cubit.close();
  });

  test('storage events win over the optimistic state', () async {
    when(() => toggleFavorite(any()))
        .thenAnswer((_) async => const Err(CacheFailure(message: 'disk full')));
    final cubit = build();

    await cubit.toggle(movie(1));
    storage.add(const {});
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isEmpty);
    await cubit.close();
  });
}
