import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../movies/domain/entities/movie.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../domain/usecases/watch_favorite_ids.dart';

class FavoriteIdsCubit extends Cubit<Set<int>> {
  final WatchFavoriteIds watchFavoriteIds;
  final ToggleFavorite toggleFavoriteUseCase;

  StreamSubscription<Set<int>>? _subscription;

  FavoriteIdsCubit({
    required this.watchFavoriteIds,
    required this.toggleFavoriteUseCase,
  }) : super(const <int>{}) {
    _subscription = watchFavoriteIds().listen(
      (ids) => emit(ids),
      onError: (_) {
        // Ignore stream errors and keep the last known ids.
      },
    );
  }

  bool contains(int movieId) => state.contains(movieId);

  Future<void> toggle(Movie movie) async {
    // Optimistic update: emit before storage completes. If the write fails,
    // the next watchFavoriteIds event restores the correct state.
    final current = state;
    final next = current.contains(movie.id)
        ? (current.difference({movie.id}))
        : (current.union({movie.id}));
    emit(next);

    await toggleFavoriteUseCase(ToggleFavoriteParams(movie: movie));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
