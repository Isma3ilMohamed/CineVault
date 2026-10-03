part of 'favorites_bloc.dart';

@freezed
sealed class FavoritesEvent with _$FavoritesEvent {
  /// Sent once by the page; keeps the list in sync with storage until the
  /// bloc is closed.
  const factory FavoritesEvent.started() = FavoritesStarted;
}
