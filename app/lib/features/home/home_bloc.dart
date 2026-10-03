import 'package:bloc/bloc.dart';
import 'package:cine_vault/features/home/home_contract.dart';
import 'package:core_base/core_base.dart';
import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState>
    with EventGuard<HomeEvent, HomeState>, EffectEmitter<HomeState, HomeEffect> {
  HomeBloc({required this.getMoviesByCategory}) : super(const HomeState.initial()) {
    on<HomeStarted>((_, emit) => _load(emit));
    on<HomeRetried>((_, emit) => _load(emit));
    on<HomeRefreshed>(_onRefreshed);
  }

  final GetMoviesByCategory getMoviesByCategory;

  @override
  bool isEventAllowed(HomeEvent event, HomeState state) => switch ((state, event)) {
    (HomeInitial(), HomeStarted()) => true,
    (HomeError(), HomeRetried()) => true,
    (HomeLoaded(isRefreshing: false), HomeRefreshed()) => true,
    _ => false,
  };

  Future<void> _load(Emitter<HomeState> emit) async {
    emit(const HomeState.loading());
    switch (await _fetchSections()) {
      case Err(:final failure):
        emit(HomeState.error(failure));
      case Ok(value: final sections):
        emit(HomeState.loaded(sections: sections));
    }
  }

  /// A failed refresh keeps what is on screen and reports it as an effect,
  /// instead of replacing the whole screen with an error.
  Future<void> _onRefreshed(HomeRefreshed event, Emitter<HomeState> emit) async {
    final current = state;
    if (current is! HomeLoaded) return;
    emit(current.copyWith(isRefreshing: true));
    switch (await _fetchSections()) {
      case Err(:final failure):
        emit(current);
        emitEffect(HomeEffect.refreshFailed(failure));
      case Ok(value: final sections):
        emit(HomeState.loaded(sections: sections));
    }
  }

  /// All categories in parallel. Any failure fails the whole screen.
  Future<Result<Map<MovieCategory, List<Movie>>>> _fetchSections() async {
    const categories = MovieCategory.values;
    final results = await Future.wait([
      for (final category in categories)
        getMoviesByCategory(MoviesByCategoryParams(category: category)),
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
