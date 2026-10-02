import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/favorites/data/datasources/local/favorites_local_data_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/is_favorite.dart';
import '../../features/favorites/domain/usecases/toggle_favorite.dart';
import '../../features/favorites/domain/usecases/watch_favorite_ids.dart';
import '../../features/favorites/domain/usecases/watch_favorites.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';
import '../../features/favorites/presentation/cubit/favorite_ids_cubit.dart';
import '../../features/movies/data/datasources/remote/movie_remote_data_source.dart';
import '../../features/movies/data/repositories/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/domain/usecases/get_genres.dart';
import '../../features/movies/domain/usecases/get_movie_credits.dart';
import '../../features/movies/domain/usecases/get_movie_details.dart';
import '../../features/movies/domain/usecases/get_movie_videos.dart';
import '../../features/movies/domain/usecases/get_popular_movies.dart';
import '../../features/movies/domain/usecases/get_similar_movies.dart';
import '../../features/movies/domain/entities/movie_category.dart';
import '../../features/movies/presentation/bloc/movie_details_bloc.dart';
import '../../features/movies/presentation/bloc/movie_list_bloc.dart';
import '../../features/movies/presentation/bloc/movies_bloc.dart';
import '../../features/movies/presentation/cubit/genres_cubit.dart';
import '../../features/search/data/datasources/local/recent_searches_local_data_source.dart';
import '../../features/search/data/datasources/remote/search_remote_data_source.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/clear_recent_searches.dart';
import '../../features/search/domain/usecases/get_recent_searches.dart';
import '../../features/search/domain/usecases/save_recent_search.dart';
import '../../features/search/domain/usecases/search_movies.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';
import '../../features/settings/data/datasources/local/settings_local_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings.dart';
import '../../features/settings/domain/usecases/save_locale.dart';
import '../../features/settings/domain/usecases/save_theme_mode.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../config/app_config.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

/// ببساطة كدا: ده الـ DI container
/// كل الـ dependencies بيتسجلوا هنا مرة واحدة في main()
/// وبعد كدا بنطلبها في أي مكان: sl<MoviesBloc>()
///
/// Compare مع Kee (Koin):
///   val appModule = module {
///     single { DioClient() }
///     single<MovieRepository> { MovieRepositoryImpl(get(), get()) }
///     factory { MoviesBloc(get(), get()) }
///   }
///
/// أنواع التسجيل:
///   - registerSingleton: instance واحدة للتطبيق كله (زي Koin single)
///   - registerLazySingleton: بيتعمل لما نحتاجه لأول مرة
///   - registerFactory: كل مرة نطلبه بيعمل instance جديدة (زي Koin factory)
final sl = GetIt.instance; // sl = Service Locator

Future<void> initDependencies(AppConfig config) async {
  sl.registerSingleton<AppConfig>(config);

  //! External
  sl.registerLazySingleton(() => Connectivity());

  // SharedPreferences لازم يتنادى بـ await، فبنعمل له registerSingletonAsync
  // وبنستنى initialization يخلص في main() قبل ما نشغل الـ app
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Hive: initFlutter بيهيئ الـ path. بعدين نفتح الـ box للـ favorites
  await Hive.initFlutter();
  final favoritesBox =
      await Hive.openBox<dynamic>(FavoritesLocalDataSourceImpl.boxName);
  sl.registerLazySingleton<Box<dynamic>>(() => favoritesBox);

  //! Core
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! Features - Movies
  // Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl()));
  sl.registerLazySingleton(() => GetSimilarMovies(sl()));
  sl.registerLazySingleton(() => GetGenres(sl()));
  sl.registerLazySingleton(() => GetMovieCredits(sl()));
  sl.registerLazySingleton(() => GetMovieVideos(sl()));

  // GenresCubit — global cache, lazy singleton (one instance for the app)
  sl.registerLazySingleton(() => GenresCubit(getGenres: sl()));

  // Bloc - factory عشان كل screen تاخد instance جديدة
  sl.registerFactory(
    () => MoviesBloc(
      getPopularMovies: sl(),
      movieRepository: sl(),
    ),
  );
  sl.registerFactory(
    () => MovieDetailsBloc(
      getMovieDetails: sl(),
      getSimilarMovies: sl(),
      getMovieCredits: sl(),
      getMovieVideos: sl(),
    ),
  );
  // Factory with parameter — كل MovieListPage ياخد instance مخصصة
  sl.registerFactoryParam<MovieListBloc, MovieCategory, void>(
    (category, _) => MovieListBloc(
      repository: sl(),
      category: category,
    ),
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
    () => SearchRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
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
    () => FavoriteIdsCubit(
      watchFavoriteIds: sl(),
      toggleFavoriteUseCase: sl(),
    ),
  );

  // Page bloc (factory — new instance per FavoritesPage open)
  sl.registerFactory(
    () => FavoritesBloc(watchFavorites: sl()),
  );

  //! Features - Settings
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => SaveThemeMode(sl()));
  sl.registerLazySingleton(() => SaveLocale(sl()));

  // SettingsCubit بيقرا الـ initial settings من الـ storage قبل الـ app ما يشتغل
  // فبنعمله registerSingletonAsync علشان الـ app يستناه
  final settingsCubit = await SettingsCubit.create(
    getSettings: sl(),
    saveThemeMode: sl(),
    saveLocale: sl(),
  );
  sl.registerSingleton<SettingsCubit>(settingsCubit);
}
