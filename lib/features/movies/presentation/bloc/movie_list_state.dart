part of 'movie_list_bloc.dart';

sealed class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object?> get props => [];
}

final class MovieListInitial extends MovieListState {
  const MovieListInitial();
}

final class MovieListLoading extends MovieListState {
  const MovieListLoading();
}

final class MovieListLoaded extends MovieListState {
  const MovieListLoaded({
    required this.movies,
    required this.page,
    required this.hasReachedMax,
    this.isLoadingMore = false,
  });
  final List<Movie> movies;
  final int page;
  final bool hasReachedMax;
  final bool isLoadingMore;

  MovieListLoaded copyWith({
    List<Movie>? movies,
    int? page,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return MovieListLoaded(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [movies, page, hasReachedMax, isLoadingMore];
}

final class MovieListError extends MovieListState {
  const MovieListError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
