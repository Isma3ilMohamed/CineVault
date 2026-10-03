part of 'favorites_bloc.dart';

@freezed
sealed class FavoritesState with _$FavoritesState {
  const factory FavoritesState.initial() = FavoritesInitial;

  /// All favorites at once: they are few and stored locally, so no paging.
  /// An empty list is a normal loaded state, not a separate one.
  const factory FavoritesState.loaded(List<Movie> movies) = FavoritesLoaded;
}
