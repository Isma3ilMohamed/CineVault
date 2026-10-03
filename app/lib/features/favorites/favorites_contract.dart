import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorites_contract.freezed.dart';

@freezed
sealed class FavoritesState with _$FavoritesState {
  const factory FavoritesState.initial() = FavoritesInitial;

  /// All favorites at once: they are few and stored locally, so no paging.
  /// An empty list is a normal loaded state, not a separate one.
  const factory FavoritesState.loaded(List<Movie> movies) = FavoritesLoaded;
}

@freezed
sealed class FavoritesEvent with _$FavoritesEvent {
  /// Sent once by the Route; keeps the list in sync with storage until the
  /// bloc is closed.
  const factory FavoritesEvent.started() = FavoritesStarted;
}

// No FavoritesEffect: storage updates arrive as state, taps are navigation.
