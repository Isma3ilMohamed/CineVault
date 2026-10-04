part of 'movie_list_bloc.dart';

@freezed
sealed class MovieListState with _$MovieListState {
  const factory MovieListState.initial() = MovieListInitial;

  const factory MovieListState.loading() = MovieListLoading;

  const factory MovieListState.loaded({
    required List<Movie> movies,
    required int page,
    required bool hasReachedMax,
    @Default(false) bool isLoadingMore,
  }) = MovieListLoaded;

  const factory MovieListState.error(Failure failure) = MovieListError;
}
