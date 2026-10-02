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
  final List<Movie> movies;

  const _FavoritesUpdated(this.movies);

  @override
  List<Object> get props => [movies];
}
