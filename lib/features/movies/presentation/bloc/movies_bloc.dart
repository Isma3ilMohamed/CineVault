import 'package:cine_vault/core/result/result.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:cine_vault/features/movies/domain/repositories/movie_repository.dart';
import 'package:cine_vault/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc({required this.getPopularMovies, required this.movieRepository})
    : super(const MoviesInitial()) {
    on<LoadHomeMovies>(_onLoadHomeMovies);
    on<RefreshHomeMovies>(_onRefreshHomeMovies);
    on<LoadMorePopularMovies>(_onLoadMorePopular);
  }
  final GetPopularMovies getPopularMovies;
  final MovieRepository movieRepository;

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
      getPopularMovies(const PageParams(page: 1)),
      movieRepository.getTopRatedMovies(page: 1),
      movieRepository.getUpcomingMovies(page: 1),
      movieRepository.getNowPlayingMovies(page: 1),
      movieRepository.getTrendingDayMovies(page: 1),
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
    final result = await getPopularMovies(PageParams(page: nextPage));

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
