import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_list/src/movie_list_bloc.dart';

/// Registers this feature's bloc. The use cases must already be registered.
void registerMovieListDependencies(GetIt getIt) {
  getIt.registerFactoryParam<MovieListBloc, MovieCategory, void>(
    (category, _) => MovieListBloc(category: category, getMoviesByCategory: getIt()),
  );
}
