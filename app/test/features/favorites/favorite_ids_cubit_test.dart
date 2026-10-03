import 'dart:async';

import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/favorites_repository.dart';
import 'package:cine_vault/features/favorites/favorites.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'fixtures.dart';

class _MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late _MockFavoritesRepository repository;
  late StreamController<Set<int>> storage;

  setUpAll(() => registerFallbackValue(movie(0)));

  setUp(() {
    repository = _MockFavoritesRepository();
    storage = StreamController<Set<int>>();
    when(() => repository.watchFavoriteIds()).thenAnswer((_) => storage.stream);
  });

  tearDown(() => storage.close());

  FavoriteIdsCubit build() => FavoriteIdsCubit(favoritesRepository: repository);

  test('toggle flips the heart before storage answers', () async {
    final write = Completer<Result<bool>>();
    when(() => repository.toggleFavorite(any())).thenAnswer((_) => write.future);
    final cubit = build();

    unawaited(cubit.toggle(movie(1)));
    expect(cubit.state, {1});

    write.complete(const Ok(true));
    await cubit.close();
  });

  test('storage events win over the optimistic state', () async {
    when(() => repository.toggleFavorite(any()))
        .thenAnswer((_) async => const Err(CacheFailure(message: 'disk full')));
    final cubit = build();

    await cubit.toggle(movie(1));
    storage.add(const {});
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isEmpty);
    await cubit.close();
  });
}
