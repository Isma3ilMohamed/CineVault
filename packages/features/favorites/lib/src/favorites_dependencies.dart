import 'package:favorites/src/favorite_ids_cubit.dart';
import 'package:favorites/src/favorites_bloc.dart';
import 'package:get_it/get_it.dart';

/// Registers this feature's state holders. The use cases must already be
/// registered.
void registerFavoritesDependencies(GetIt getIt) {
  getIt
    // One instance for the app: every heart button reads the same set.
    ..registerLazySingleton(
      () => FavoriteIdsCubit(watchFavoriteIds: getIt(), toggleFavorite: getIt()),
    )
    ..registerFactory(() => FavoritesBloc(watchFavorites: getIt()));
}
