import 'package:bloc/bloc.dart';
import 'package:core_base/core_base.dart';
import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_list/src/movie_list_contract.dart';

@injectable
class MovieListBloc extends Bloc<MovieListEvent, MovieListState>
    with EventGuard<MovieListEvent, MovieListState> {
  MovieListBloc({@factoryParam required this.category, required this.getMoviesByCategory})
    : super(const MovieListState.initial()) {
    on<MovieListStarted>((_, emit) => _loadFirstPage(emit));
    on<MovieListRetried>((_, emit) => _loadFirstPage(emit));
    on<MovieListLoadMoreRequested>((_, emit) => _loadNextPage(emit));
  }

  final MovieCategory category;
  final GetMoviesByCategory getMoviesByCategory;

  /// Load more is allowed in any loaded state on purpose: the grid keeps
  /// reporting scrolls until it rebuilds with `isLoadingMore`, so the extra
  /// requests are expected and dropped by [_loadNextPage] instead.
  @override
  bool isEventAllowed(MovieListEvent event, MovieListState state) => switch ((state, event)) {
    (MovieListInitial(), MovieListStarted()) => true,
    (MovieListError(), MovieListRetried()) => true,
    (MovieListLoaded(), MovieListLoadMoreRequested()) => true,
    _ => false,
  };

  Future<Result<List<Movie>>> _fetch(int page) =>
      getMoviesByCategory(MoviesByCategoryParams(category: category, page: page));

  Future<void> _loadFirstPage(Emitter<MovieListState> emit) async {
    emit(const MovieListState.loading());
    switch (await _fetch(1)) {
      case Err(:final failure):
        emit(MovieListState.error(failure));
      case Ok(value: final movies):
        emit(MovieListState.loaded(movies: movies, page: 1, hasReachedMax: movies.isEmpty));
    }
  }

  Future<void> _loadNextPage(Emitter<MovieListState> emit) async {
    final current = state;
    if (current is! MovieListLoaded || current.hasReachedMax || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    final nextPage = current.page + 1;
    switch (await _fetch(nextPage)) {
      case Err():
        emit(current);
      case Ok(value: final movies):
        emit(
          current.copyWith(
            movies: [...current.movies, ...movies],
            page: nextPage,
            hasReachedMax: movies.isEmpty,
          ),
        );
    }
  }
}
