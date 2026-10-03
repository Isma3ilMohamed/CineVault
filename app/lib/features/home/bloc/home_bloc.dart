import 'package:bloc/bloc.dart';
import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/movie_repository.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.movieRepository}) : super(const HomeState.initial()) {
    on<HomeStarted>((_, emit) => _load(emit));
    on<HomeRetried>((_, emit) => _load(emit));
    on<HomeRefreshed>(_onRefreshed);
  }

  final MovieRepository movieRepository;

  Future<void> _load(Emitter<HomeState> emit) async {
    emit(const HomeState.loading());
    switch (await _fetchSections()) {
      case Err(:final failure):
        emit(HomeState.error(failure));
      case Ok(value: final sections):
        emit(HomeState.loaded(sections: sections));
    }
  }

  /// A failed refresh keeps what is on screen and sets [HomeLoaded.refreshFailure]
  /// (the view shows a snackbar), instead of replacing the screen with an error.
  /// Ignored while a refresh is already running.
  Future<void> _onRefreshed(HomeRefreshed event, Emitter<HomeState> emit) async {
    final current = state;
    if (current is! HomeLoaded || current.isRefreshing) return;
    emit(current.copyWith(isRefreshing: true, refreshFailure: null));
    switch (await _fetchSections()) {
      case Err(:final failure):
        emit(current.copyWith(refreshFailure: failure));
      case Ok(value: final sections):
        emit(HomeState.loaded(sections: sections));
    }
  }

  /// All categories in parallel. Any failure fails the whole screen.
  Future<Result<Map<MovieCategory, List<Movie>>>> _fetchSections() async {
    const categories = MovieCategory.values;
    final results = await Future.wait([
      for (final category in categories) movieRepository.getMoviesByCategory(category),
    ]);

    final sections = <MovieCategory, List<Movie>>{};
    for (final (index, result) in results.indexed) {
      switch (result) {
        case Err(:final failure):
          return Err(failure);
        case Ok(value: final movies):
          sections[categories[index]] = movies;
      }
    }
    return Ok(sections);
  }
}
