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
  final List<Movie> movies;
  final int page;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const MovieListLoaded({
    required this.movies,
    required this.page,
    required this.hasReachedMax,
    this.isLoadingMore = false,
  });

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
  final String message;

  const MovieListError({required this.message});

  @override
  List<Object> get props => [message];
}
