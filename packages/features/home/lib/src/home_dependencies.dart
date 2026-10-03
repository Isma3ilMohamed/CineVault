import 'package:get_it/get_it.dart';
import 'package:home/src/home_bloc.dart';

/// Registers this feature's bloc. The use cases must already be registered.
void registerHomeDependencies(GetIt getIt) {
  getIt.registerFactory(() => HomeBloc(getMoviesByCategory: getIt()));
}
