import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';

/// App-wide set of favorite movie ids, behind every heart button.
///
/// One instance for the whole app (provided above the router), so a toggle on
/// any screen updates the hearts on every other screen.
class FavoriteIdsCubit extends Cubit<Set<int>> {
  FavoriteIdsCubit({required this.watchFavoriteIds, required this.toggleFavorite})
    : super(const <int>{}) {
    _subscription = watchFavoriteIds().listen(
      emit,
      onError: (_) {
        // Keep the last known ids.
      },
    );
  }

  final WatchFavoriteIds watchFavoriteIds;
  final ToggleFavorite toggleFavorite;

  StreamSubscription<Set<int>>? _subscription;

  /// Optimistic: the heart flips before storage completes. If the write fails,
  /// the next storage event restores the correct state.
  Future<void> toggle(Movie movie) async {
    final ids = state;
    emit(ids.contains(movie.id) ? ids.difference({movie.id}) : ids.union({movie.id}));
    await toggleFavorite(ToggleFavoriteParams(movie: movie));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}
