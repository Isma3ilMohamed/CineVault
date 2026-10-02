part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

/// بيتبعت مرة واحدة لما الصفحة تفتح — يشترك في watchFavorites
final class FavoritesSubscribed extends FavoritesEvent {
  const FavoritesSubscribed();
}

/// Internal event — كل مرة الـ stream يبعت snapshot
final class _FavoritesUpdated extends FavoritesEvent {
  final List<Movie> movies;

  const _FavoritesUpdated(this.movies);

  @override
  List<Object> get props => [movies];
}
