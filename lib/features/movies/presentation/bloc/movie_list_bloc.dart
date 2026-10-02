import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/result.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_category.dart';
import '../../domain/repositories/movie_repository.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieRepository repository;
  final MovieCategory category;

  MovieListBloc({
    required this.repository,
    required this.category,
  }) : super(const MovieListInitial()) {
    on<MovieListStarted>(_onStarted);
    on<MovieListLoadMore>(_onLoadMore);
    on<MovieListRetried>((_, emit) => _onStarted(const MovieListStarted(), emit));
  }

  Future<Result<List<Movie>>> _fetch(int page) {
    return switch (category) {
      MovieCategory.trending => repository.getTrendingDayMovies(page: page),
      MovieCategory.popular => repository.getPopularMovies(page: page),
      MovieCategory.topRated => repository.getTopRatedMovies(page: page),
      MovieCategory.nowPlaying => repository.getNowPlayingMovies(page: page),
      MovieCategory.upcoming => repository.getUpcomingMovies(page: page),
    };
  }

  Future<void> _onStarted(
    MovieListStarted event,
    Emitter<MovieListState> emit,
  ) async {
    emit(const MovieListLoading());
    final result = await _fetch(1);
    switch (result) {
      case Err(:final failure):
        emit(MovieListError(message: failure.message));
      case Ok(:final value):
        emit(MovieListLoaded(
          movies: value,
          page: 1,
          hasReachedMax: value.isEmpty,
        ));
    }
  }

  Future<void> _onLoadMore(
    MovieListLoadMore event,
    Emitter<MovieListState> emit,
  ) async {
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
        emit(current.copyWith(
          movies: [...current.movies, ...value],
          page: nextPage,
          hasReachedMax: value.isEmpty,
          isLoadingMore: false,
        ));
    }
  }
}
