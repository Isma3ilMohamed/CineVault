import 'dart:async';

import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteIdsCubit extends Cubit<Set<int>> {
  FavoriteIdsCubit({required this.watchFavoriteIds, required this.toggleFavoriteUseCase})
    : super(const <int>{}) {
    _subscription = watchFavoriteIds().listen(
      emit,
      onError: (_) {
        // Ignore stream errors and keep the last known ids.
      },
    );
  }
  final WatchFavoriteIds watchFavoriteIds;
  final ToggleFavorite toggleFavoriteUseCase;

  StreamSubscription<Set<int>>? _subscription;

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
    await super.close();
  }
}
