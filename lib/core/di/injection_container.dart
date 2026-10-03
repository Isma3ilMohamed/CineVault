import 'package:cine_vault/core/config/app_config.dart';
import 'package:cine_vault/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:cine_vault/features/favorites/presentation/cubit/favorite_ids_cubit.dart';
import 'package:cine_vault/features/movies/presentation/bloc/movie_details_bloc.dart';
import 'package:cine_vault/features/movies/presentation/bloc/movie_list_bloc.dart';
import 'package:cine_vault/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:cine_vault/features/movies/presentation/cubit/genres_cubit.dart';
import 'package:cine_vault/features/search/presentation/bloc/search_bloc.dart';
import 'package:cine_vault/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies(AppConfig config) async {
  sl.registerSingleton<AppConfig>(config);

  //! External

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  await Hive.initFlutter();
  final favoritesBox = await Hive.openBox<dynamic>(FavoritesLocalDataSourceImpl.boxName);
  sl.registerLazySingleton<Box<dynamic>>(() => favoritesBox);

  //! Core
  sl.registerLazySingleton(
    () => DioClient(
      baseUrl: config.tmdbBaseUrl,
      accessToken: config.tmdbAccessToken,
      enableNetworkLogs: config.enableNetworkLogs,
    ),
  );

  //! Features - Movies
  // Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  // Repository
  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(remoteDataSource: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetMoviesByCategory(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl()));
  sl.registerLazySingleton(() => GetSimilarMovies(sl()));
  sl.registerLazySingleton(() => GetGenres(sl()));
  sl.registerLazySingleton(() => GetMovieCredits(sl()));
  sl.registerLazySingleton(() => GetMovieTrailer(sl()));

  // GenresCubit — global cache, lazy singleton (one instance for the app)
  sl.registerLazySingleton(() => GenresCubit(getGenres: sl()));

  // Blocs are factories so each screen gets a fresh instance
  sl.registerFactory(() => MoviesBloc(getMoviesByCategory: sl()));
  sl.registerFactory(
    () => MovieDetailsBloc(
      getMovieDetails: sl(),
      getSimilarMovies: sl(),
      getMovieCredits: sl(),
      getMovieTrailer: sl(),
    ),
  );
  sl.registerFactoryParam<MovieListBloc, MovieCategory, void>(
    (category, _) => MovieListBloc(getMoviesByCategory: sl(), category: category),
  );

  //! Features - Search
  // Data sources
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<RecentSearchesLocalDataSource>(
    () => RecentSearchesLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetRecentSearches(sl()));
  sl.registerLazySingleton(() => SaveRecentSearch(sl()));
  sl.registerLazySingleton(() => ClearRecentSearches(sl()));

  // Bloc
  sl.registerFactory(
    () => SearchBloc(
      searchMoviesUseCase: sl(),
      getRecentSearchesUseCase: sl(),
      saveRecentSearchUseCase: sl(),
      clearRecentSearchesUseCase: sl(),
    ),
  );

  //! Features - Favorites
  // Data sources
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sl<Box<dynamic>>()),
  );

  // Repository
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => WatchFavorites(sl()));
  sl.registerLazySingleton(() => WatchFavoriteIds(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => IsFavorite(sl()));

  // Cubit (global, one instance at app root — singleton)
  sl.registerLazySingleton(
    () => FavoriteIdsCubit(watchFavoriteIds: sl(), toggleFavoriteUseCase: sl()),
  );

  // Page bloc (factory — new instance per FavoritesPage open)
  sl.registerFactory(() => FavoritesBloc(watchFavorites: sl()));

  //! Features - Settings
  sl.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => SaveThemeMode(sl()));
  sl.registerLazySingleton(() => SaveLanguage(sl()));

  // Awaited so the persisted theme/locale are loaded before the first frame
  final settingsCubit = await SettingsCubit.create(
    getSettings: sl(),
    saveThemeMode: sl(),
    saveLanguage: sl(),
  );
  sl.registerSingleton<SettingsCubit>(settingsCubit);
}
