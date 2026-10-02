part of 'movies_bloc.dart';

sealed class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeMovies extends MoviesEvent {
  const LoadHomeMovies();
}

class RefreshHomeMovies extends MoviesEvent {
  const RefreshHomeMovies();
}

class LoadMorePopularMovies extends MoviesEvent {
  const LoadMorePopularMovies();
}
