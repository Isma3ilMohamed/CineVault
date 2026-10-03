import 'package:cine_vault/core/config/app_config.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:favorites/favorites.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home/home.dart';
import 'package:movie_details/movie_details.dart';
import 'package:movie_list/movie_list.dart';
import 'package:search/search.dart';
import 'package:settings/settings.dart';
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

  //! Features - Settings
  sl.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => SaveThemeMode(sl()));
  sl.registerLazySingleton(() => SaveLanguage(sl()));

  //! Features: each one registers its own blocs and app-wide state
  registerHomeDependencies(sl);
  registerMovieListDependencies(sl);
  registerMovieDetailsDependencies(sl);
  registerSearchDependencies(sl);
  registerFavoritesDependencies(sl);
  // Awaited so the persisted theme/locale are loaded before the first frame
  await registerSettingsDependencies(sl);
}
