import 'package:cine_vault/app/config/app_config.dart';
import 'package:cine_vault/data/network/dio_client.dart';
import 'package:cine_vault/data/network/network_config.dart';
import 'package:cine_vault/data/repositories/favorites_repository.dart';
import 'package:cine_vault/data/repositories/favorites_repository_impl.dart';
import 'package:cine_vault/data/repositories/movie_repository.dart';
import 'package:cine_vault/data/repositories/movie_repository_impl.dart';
import 'package:cine_vault/data/repositories/search_repository.dart';
import 'package:cine_vault/data/repositories/search_repository_impl.dart';
import 'package:cine_vault/data/repositories/settings_repository.dart';
import 'package:cine_vault/data/repositories/settings_repository_impl.dart';
import 'package:cine_vault/data/sources/favorites_local_data_source.dart';
import 'package:cine_vault/data/sources/movie_remote_data_source.dart';
import 'package:cine_vault/data/sources/recent_searches_local_data_source.dart';
import 'package:cine_vault/data/sources/search_remote_data_source.dart';
import 'package:cine_vault/data/sources/settings_local_data_source.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/favorites/bloc/favorites_bloc.dart';
import 'package:cine_vault/features/favorites/cubit/favorite_ids_cubit.dart';
import 'package:cine_vault/features/home/bloc/home_bloc.dart';
import 'package:cine_vault/features/movie_details/bloc/movie_details_bloc.dart';
import 'package:cine_vault/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:cine_vault/features/search/bloc/search_bloc.dart';
import 'package:cine_vault/features/settings/cubit/settings_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

/// Registers everything the app needs, from storage up to the blocs.
///
/// Call `Hive.initFlutter()` (or `Hive.init` in tests) first. Tests pass their
/// own [config] and can replace registrations afterwards.
Future<void> configureDependencies(AppConfig config) async {
  getIt.registerSingleton(config);
  await _registerStorage();
  _registerNetwork(config);
  _registerRepositories();
  await _registerAppState();
  _registerBlocs();
}

/// Opened once at startup, so the data sources can read synchronously.
Future<void> _registerStorage() async {
  final preferences = await SharedPreferences.getInstance();
  final favoritesBox = await Hive.openBox<dynamic>(FavoritesLocalDataSourceImpl.boxName);
  getIt
    ..registerSingleton(preferences)
    ..registerSingleton<Box<dynamic>>(favoritesBox);
}

void _registerNetwork(AppConfig config) {
  getIt
    ..registerLazySingleton(
      () => DioClient(
        NetworkConfig(
          baseUrl: config.tmdbBaseUrl,
          accessToken: config.tmdbAccessToken,
          enableNetworkLogs: config.enableNetworkLogs,
        ),
      ),
    )
    ..registerLazySingleton<Dio>(() => getIt<DioClient>().dio);
}

void _registerRepositories() {
  getIt
    ..registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(remoteDataSource: MovieRemoteDataSourceImpl(getIt())),
    )
    ..registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(
        remoteDataSource: SearchRemoteDataSourceImpl(getIt()),
        localDataSource: RecentSearchesLocalDataSourceImpl(getIt()),
      ),
    )
    ..registerLazySingleton<FavoritesRepository>(
      () => FavoritesRepositoryImpl(localDataSource: FavoritesLocalDataSourceImpl(getIt())),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(localDataSource: SettingsLocalDataSourceImpl(getIt())),
    );
}

/// One instance for the whole app, provided above MaterialApp.
Future<void> _registerAppState() async {
  // Resolved now, so the first frame already uses the saved theme and locale.
  final settings = await SettingsCubit.create(settingsRepository: getIt());
  getIt
    ..registerSingleton(settings)
    ..registerLazySingleton(() => FavoriteIdsCubit(favoritesRepository: getIt()));
}

/// A new bloc for every screen that asks for one.
void _registerBlocs() {
  getIt
    ..registerFactory(() => HomeBloc(movieRepository: getIt()))
    ..registerFactoryParam<MovieListBloc, MovieCategory, void>(
      (category, _) => MovieListBloc(category: category, movieRepository: getIt()),
    )
    ..registerFactoryParam<MovieDetailsBloc, int, void>(
      (movieId, _) => MovieDetailsBloc(movieId: movieId, movieRepository: getIt()),
    )
    ..registerFactory(() => SearchBloc(searchRepository: getIt()))
    ..registerFactory(() => FavoritesBloc(favoritesRepository: getIt()));
}
