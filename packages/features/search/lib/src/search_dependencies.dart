import 'package:get_it/get_it.dart';
import 'package:search/src/search_bloc.dart';

/// Registers this feature's bloc. The use cases must already be registered.
void registerSearchDependencies(GetIt getIt) {
  getIt.registerFactory(
    () => SearchBloc(
      searchMovies: getIt(),
      getRecentSearches: getIt(),
      saveRecentSearch: getIt(),
      clearRecentSearches: getIt(),
    ),
  );
}
