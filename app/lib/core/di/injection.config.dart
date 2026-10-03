// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cine_vault/core/config/app_config.dart' as _i704;
import 'package:cine_vault/core/di/injection.dart' as _i879;
import 'package:cine_vault/data/data_module.dart' as _i457;
import 'package:cine_vault/data/network/dio_client.dart' as _i375;
import 'package:cine_vault/data/network/network_config.dart' as _i897;
import 'package:cine_vault/data/repositories/favorites_repository.dart'
    as _i271;
import 'package:cine_vault/data/repositories/favorites_repository_impl.dart'
    as _i147;
import 'package:cine_vault/data/repositories/movie_repository.dart' as _i202;
import 'package:cine_vault/data/repositories/movie_repository_impl.dart'
    as _i609;
import 'package:cine_vault/data/repositories/search_repository.dart' as _i315;
import 'package:cine_vault/data/repositories/search_repository_impl.dart'
    as _i898;
import 'package:cine_vault/data/repositories/settings_repository.dart' as _i263;
import 'package:cine_vault/data/repositories/settings_repository_impl.dart'
    as _i937;
import 'package:cine_vault/data/sources/favorites_local_data_source.dart'
    as _i86;
import 'package:cine_vault/data/sources/movie_remote_data_source.dart' as _i244;
import 'package:cine_vault/data/sources/recent_searches_local_data_source.dart'
    as _i626;
import 'package:cine_vault/data/sources/search_remote_data_source.dart'
    as _i157;
import 'package:cine_vault/data/sources/settings_local_data_source.dart'
    as _i250;
import 'package:cine_vault/domain/domain.dart' as _i227;
import 'package:cine_vault/domain/usecases/favorites/is_favorite.dart' as _i981;
import 'package:cine_vault/domain/usecases/favorites/toggle_favorite.dart'
    as _i417;
import 'package:cine_vault/domain/usecases/favorites/watch_favorite_ids.dart'
    as _i903;
import 'package:cine_vault/domain/usecases/favorites/watch_favorites.dart'
    as _i641;
import 'package:cine_vault/domain/usecases/movies/get_genres.dart' as _i996;
import 'package:cine_vault/domain/usecases/movies/get_movie_credits.dart'
    as _i1000;
import 'package:cine_vault/domain/usecases/movies/get_movie_details.dart'
    as _i988;
import 'package:cine_vault/domain/usecases/movies/get_movie_trailer.dart'
    as _i176;
import 'package:cine_vault/domain/usecases/movies/get_movies_by_category.dart'
    as _i891;
import 'package:cine_vault/domain/usecases/movies/get_similar_movies.dart'
    as _i895;
import 'package:cine_vault/domain/usecases/search/clear_recent_searches.dart'
    as _i583;
import 'package:cine_vault/domain/usecases/search/get_recent_searches.dart'
    as _i57;
import 'package:cine_vault/domain/usecases/search/save_recent_search.dart'
    as _i467;
import 'package:cine_vault/domain/usecases/search/search_movies.dart' as _i943;
import 'package:cine_vault/domain/usecases/settings/get_settings.dart' as _i729;
import 'package:cine_vault/domain/usecases/settings/save_language.dart'
    as _i692;
import 'package:cine_vault/domain/usecases/settings/save_theme_mode.dart'
    as _i59;
import 'package:cine_vault/features/favorites/bloc/favorites_bloc.dart'
    as _i508;
import 'package:cine_vault/features/favorites/cubit/favorite_ids_cubit.dart'
    as _i733;
import 'package:cine_vault/features/home/bloc/home_bloc.dart' as _i236;
import 'package:cine_vault/features/movie_details/bloc/movie_details_bloc.dart'
    as _i901;
import 'package:cine_vault/features/movie_list/bloc/movie_list_bloc.dart'
    as _i515;
import 'package:cine_vault/features/search/bloc/search_bloc.dart' as _i719;
import 'package:cine_vault/features/settings/cubit/settings_cubit.dart' as _i28;
import 'package:cine_vault/features/settings/cubit/settings_module.dart'
    as _i344;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dataModule = _$DataModule();
    final appModule = _$AppModule();
    final settingsModule = _$SettingsModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => dataModule.preferences,
      preResolve: true,
    );
    await gh.singletonAsync<_i979.Box<dynamic>>(
      () => dataModule.favoritesBox,
      preResolve: true,
    );
    gh.lazySingleton<_i86.FavoritesLocalDataSource>(
      () => _i86.FavoritesLocalDataSourceImpl(gh<_i979.Box<dynamic>>()),
    );
    gh.lazySingleton<_i227.FavoritesRepository>(
      () => _i147.FavoritesRepositoryImpl(
        localDataSource: gh<_i86.FavoritesLocalDataSource>(),
      ),
    );
    gh.singleton<_i897.NetworkConfig>(
      () => appModule.networkConfig(gh<_i704.AppConfig>()),
    );
    gh.lazySingleton<_i375.DioClient>(
      () => _i375.DioClient(gh<_i897.NetworkConfig>()),
    );
    gh.lazySingleton<_i250.SettingsLocalDataSource>(
      () => _i250.SettingsLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i626.RecentSearchesLocalDataSource>(
      () => _i626.RecentSearchesLocalDataSourceImpl(
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i227.SettingsRepository>(
      () => _i937.SettingsRepositoryImpl(
        localDataSource: gh<_i250.SettingsLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(() => dataModule.dio(gh<_i375.DioClient>()));
    gh.lazySingleton<_i981.IsFavorite>(
      () => _i981.IsFavorite(gh<_i271.FavoritesRepository>()),
    );
    gh.lazySingleton<_i417.ToggleFavorite>(
      () => _i417.ToggleFavorite(gh<_i271.FavoritesRepository>()),
    );
    gh.lazySingleton<_i903.WatchFavoriteIds>(
      () => _i903.WatchFavoriteIds(gh<_i271.FavoritesRepository>()),
    );
    gh.lazySingleton<_i641.WatchFavorites>(
      () => _i641.WatchFavorites(gh<_i271.FavoritesRepository>()),
    );
    gh.factory<_i508.FavoritesBloc>(
      () => _i508.FavoritesBloc(watchFavorites: gh<_i227.WatchFavorites>()),
    );
    gh.lazySingleton<_i244.MovieRemoteDataSource>(
      () => _i244.MovieRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i729.GetSettings>(
      () => _i729.GetSettings(gh<_i263.SettingsRepository>()),
    );
    gh.lazySingleton<_i692.SaveLanguage>(
      () => _i692.SaveLanguage(gh<_i263.SettingsRepository>()),
    );
    gh.lazySingleton<_i59.SaveThemeMode>(
      () => _i59.SaveThemeMode(gh<_i263.SettingsRepository>()),
    );
    gh.lazySingleton<_i157.SearchRemoteDataSource>(
      () => _i157.SearchRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i733.FavoriteIdsCubit>(
      () => _i733.FavoriteIdsCubit(
        watchFavoriteIds: gh<_i227.WatchFavoriteIds>(),
        toggleFavorite: gh<_i227.ToggleFavorite>(),
      ),
    );
    gh.lazySingleton<_i227.MovieRepository>(
      () => _i609.MovieRepositoryImpl(
        remoteDataSource: gh<_i244.MovieRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i996.GetGenres>(
      () => _i996.GetGenres(gh<_i202.MovieRepository>()),
    );
    gh.lazySingleton<_i1000.GetMovieCredits>(
      () => _i1000.GetMovieCredits(gh<_i202.MovieRepository>()),
    );
    gh.lazySingleton<_i988.GetMovieDetails>(
      () => _i988.GetMovieDetails(gh<_i202.MovieRepository>()),
    );
    gh.lazySingleton<_i176.GetMovieTrailer>(
      () => _i176.GetMovieTrailer(gh<_i202.MovieRepository>()),
    );
    gh.lazySingleton<_i891.GetMoviesByCategory>(
      () => _i891.GetMoviesByCategory(gh<_i202.MovieRepository>()),
    );
    gh.lazySingleton<_i895.GetSimilarMovies>(
      () => _i895.GetSimilarMovies(gh<_i202.MovieRepository>()),
    );
    gh.factoryParam<_i901.MovieDetailsBloc, int, dynamic>(
      (movieId, _) => _i901.MovieDetailsBloc(
        movieId: movieId,
        getMovieDetails: gh<_i227.GetMovieDetails>(),
        getSimilarMovies: gh<_i227.GetSimilarMovies>(),
        getMovieCredits: gh<_i227.GetMovieCredits>(),
        getMovieTrailer: gh<_i227.GetMovieTrailer>(),
        getGenres: gh<_i227.GetGenres>(),
      ),
    );
    gh.lazySingleton<_i227.SearchRepository>(
      () => _i898.SearchRepositoryImpl(
        remoteDataSource: gh<_i157.SearchRemoteDataSource>(),
        localDataSource: gh<_i626.RecentSearchesLocalDataSource>(),
      ),
    );
    gh.factory<_i236.HomeBloc>(
      () =>
          _i236.HomeBloc(getMoviesByCategory: gh<_i227.GetMoviesByCategory>()),
    );
    await gh.singletonAsync<_i28.SettingsCubit>(
      () => settingsModule.settingsCubit(
        gh<_i227.GetSettings>(),
        gh<_i227.SaveThemeMode>(),
        gh<_i227.SaveLanguage>(),
      ),
      preResolve: true,
    );
    gh.factoryParam<_i515.MovieListBloc, _i227.MovieCategory, dynamic>(
      (category, _) => _i515.MovieListBloc(
        category: category,
        getMoviesByCategory: gh<_i227.GetMoviesByCategory>(),
      ),
    );
    gh.lazySingleton<_i583.ClearRecentSearches>(
      () => _i583.ClearRecentSearches(gh<_i315.SearchRepository>()),
    );
    gh.lazySingleton<_i57.GetRecentSearches>(
      () => _i57.GetRecentSearches(gh<_i315.SearchRepository>()),
    );
    gh.lazySingleton<_i467.SaveRecentSearch>(
      () => _i467.SaveRecentSearch(gh<_i315.SearchRepository>()),
    );
    gh.lazySingleton<_i943.SearchMovies>(
      () => _i943.SearchMovies(gh<_i315.SearchRepository>()),
    );
    gh.factory<_i719.SearchBloc>(
      () => _i719.SearchBloc(
        searchMovies: gh<_i227.SearchMovies>(),
        getRecentSearches: gh<_i227.GetRecentSearches>(),
        saveRecentSearch: gh<_i227.SaveRecentSearch>(),
        clearRecentSearches: gh<_i227.ClearRecentSearches>(),
      ),
    );
    return this;
  }
}

class _$DataModule extends _i457.DataModule {}

class _$AppModule extends _i879.AppModule {}

class _$SettingsModule extends _i344.SettingsModule {}
