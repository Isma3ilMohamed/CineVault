part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded({required this.movies});
  final List<Movie> movies;

  bool get isEmpty => movies.isEmpty;

  @override
  List<Object> get props => [movies];
}
