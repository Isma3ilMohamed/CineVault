import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc({required this.getMoviesByCategory}) : super(const MoviesInitial()) {
    on<LoadHomeMovies>(_onLoadHomeMovies);
    on<RefreshHomeMovies>(_onRefreshHomeMovies);
    on<LoadMorePopularMovies>(_onLoadMorePopular);
  }
  final GetMoviesByCategory getMoviesByCategory;

  Future<void> _onLoadHomeMovies(LoadHomeMovies event, Emitter<MoviesState> emit) async {
    emit(const MoviesLoading());
    await _fetchAllCategories(emit);
  }

  Future<void> _onRefreshHomeMovies(RefreshHomeMovies event, Emitter<MoviesState> emit) async {
    // No Loading emit: RefreshIndicator owns the spinner during refresh.
    await _fetchAllCategories(emit);
  }

  Future<void> _fetchAllCategories(Emitter<MoviesState> emit) async {
    final results = await Future.wait([
      getMoviesByCategory(const MoviesByCategoryParams(category: MovieCategory.popular)),
      getMoviesByCategory(const MoviesByCategoryParams(category: MovieCategory.topRated)),
      getMoviesByCategory(const MoviesByCategoryParams(category: MovieCategory.upcoming)),
      getMoviesByCategory(const MoviesByCategoryParams(category: MovieCategory.nowPlaying)),
      getMoviesByCategory(const MoviesByCategoryParams(category: MovieCategory.trending)),
    ]);

    for (final result in results) {
      if (result case Err(:final failure)) {
        emit(MoviesError(message: failure.message));
        return;
      }
    }

    emit(
      MoviesLoaded(
        popularMovies: results[0].getOrElse(() => const []),
        topRatedMovies: results[1].getOrElse(() => const []),
        upcomingMovies: results[2].getOrElse(() => const []),
        nowPlayingMovies: results[3].getOrElse(() => const []),
        trendingDayMovies: results[4].getOrElse(() => const []),
      ),
    );
  }

  Future<void> _onLoadMorePopular(LoadMorePopularMovies event, Emitter<MoviesState> emit) async {
    final currentState = state;
    if (currentState is! MoviesLoaded) return;
    if (currentState.hasReachedMaxPopular) return;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.popularPage + 1;
    final result = await getMoviesByCategory(
      MoviesByCategoryParams(category: MovieCategory.popular, page: nextPage),
    );

    switch (result) {
      case Err():
        emit(currentState.copyWith(isLoadingMore: false));
      case Ok(:final value):
        emit(
          currentState.copyWith(
            popularMovies: [...currentState.popularMovies, ...value],
            popularPage: nextPage,
            hasReachedMaxPopular: value.isEmpty,
            isLoadingMore: false,
          ),
        );
    }
  }
}
