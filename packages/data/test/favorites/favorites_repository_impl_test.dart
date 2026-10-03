import 'dart:async';

import 'package:data/src/favorites/favorite_movie_model.dart';
import 'package:data/src/favorites/favorites_local_data_source.dart';
import 'package:data/src/favorites/favorites_repository_impl.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory stand-in for the Hive-backed data source.
class _FakeLocal implements FavoritesLocalDataSource {
  final _items = <int, FavoriteMovieModel>{};
  final _changes = StreamController<void>.broadcast();

  @override
  Future<List<FavoriteMovieModel>> getAll() async => _items.values.toList();

  @override
  Future<Set<int>> getAllIds() async => _items.keys.toSet();

  @override
  Future<bool> isFavorite(int movieId) async => _items.containsKey(movieId);

  @override
  Future<void> add(FavoriteMovieModel favorite) async {
    _items[favorite.movie.id] = favorite;
    _changes.add(null);
  }

  @override
  Future<void> remove(int movieId) async {
    _items.remove(movieId);
    _changes.add(null);
  }

  @override
  Stream<void> watch() => _changes.stream;
}

const _movie = Movie(
  id: 1,
  title: 'Dune',
  overview: '',
  voteAverage: 8,
  voteCount: 1,
  genreIds: [],
  originalLanguage: 'en',
  popularity: 1,
  adult: false,
);

void main() {
  late _FakeLocal local;
  late FavoritesRepositoryImpl repository;

  setUp(() {
    local = _FakeLocal();
    repository = FavoritesRepositoryImpl(localDataSource: local);
  });

  test('toggle adds, then removes', () async {
    expect((await repository.toggleFavorite(_movie)).valueOrNull, isTrue);
    expect((await repository.isFavorite(1)).valueOrNull, isTrue);

    expect((await repository.toggleFavorite(_movie)).valueOrNull, isFalse);
    expect((await repository.isFavorite(1)).valueOrNull, isFalse);
  });

  test('watchFavoriteIds emits the current ids, then after every change', () async {
    final emitted = <Set<int>>[];
    final sub = repository.watchFavoriteIds().listen(emitted.add);
    await pumpEventQueue();

    await repository.addFavorite(_movie);
    await pumpEventQueue();
    await repository.removeFavorite(1);
    await pumpEventQueue();

    expect(emitted, [
      <int>{},
      {1},
      <int>{},
    ]);
    await sub.cancel();
  });

  // Regression: an async* implementation hung here until the next box change.
  test('cancelling a watch completes without waiting for another change', () async {
    final sub = repository.watchFavorites().listen((_) {});
    await pumpEventQueue();

    await expectLater(sub.cancel(), completes);
  });
}
