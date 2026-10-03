import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  MovieListBloc({required this.getMoviesByCategory, required this.category})
    : super(const MovieListInitial()) {
    on<MovieListStarted>(_onStarted);
    on<MovieListLoadMore>(_onLoadMore);
    on<MovieListRetried>((_, emit) => _onStarted(const MovieListStarted(), emit));
  }
  final GetMoviesByCategory getMoviesByCategory;
  final MovieCategory category;

  Future<Result<List<Movie>>> _fetch(int page) {
    return getMoviesByCategory(MoviesByCategoryParams(category: category, page: page));
  }

  Future<void> _onStarted(MovieListStarted event, Emitter<MovieListState> emit) async {
    emit(const MovieListLoading());
    final result = await _fetch(1);
    switch (result) {
      case Err(:final failure):
        emit(MovieListError(message: failure.message));
      case Ok(:final value):
        emit(MovieListLoaded(movies: value, page: 1, hasReachedMax: value.isEmpty));
    }
  }

  Future<void> _onLoadMore(MovieListLoadMore event, Emitter<MovieListState> emit) async {
    final current = state;
    if (current is! MovieListLoaded) return;
    if (current.hasReachedMax || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = current.page + 1;
    final result = await _fetch(nextPage);

    switch (result) {
      case Err():
        emit(current.copyWith(isLoadingMore: false));
      case Ok(:final value):
        emit(
          current.copyWith(
            movies: [...current.movies, ...value],
            page: nextPage,
            hasReachedMax: value.isEmpty,
            isLoadingMore: false,
          ),
        );
    }
  }
}
