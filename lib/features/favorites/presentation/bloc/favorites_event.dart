part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

final class FavoritesSubscribed extends FavoritesEvent {
  const FavoritesSubscribed();
}

final class _FavoritesUpdated extends FavoritesEvent {
  const _FavoritesUpdated(this.movies);
  final List<Movie> movies;

  @override
  List<Object> get props => [movies];
}
