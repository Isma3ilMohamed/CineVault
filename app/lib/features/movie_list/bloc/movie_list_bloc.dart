import 'package:bloc/bloc.dart';
import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'movie_list_bloc.freezed.dart';
part 'movie_list_event.dart';
part 'movie_list_state.dart';

@injectable
class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  MovieListBloc({@factoryParam required this.category, required this.getMoviesByCategory})
    : super(const MovieListState.initial()) {
    on<MovieListStarted>((_, emit) => _loadFirstPage(emit));
    on<MovieListRetried>((_, emit) => _loadFirstPage(emit));
    on<MovieListLoadMoreRequested>((_, emit) => _loadNextPage(emit));
  }

  final MovieCategory category;
  final GetMoviesByCategory getMoviesByCategory;

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
