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
import 'package:data/data.dart' as _i437;
import 'package:domain/domain.dart' as _i494;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await _i437.DataPackageModule().init(gh);
    await _i494.DomainPackageModule().init(gh);
    final appModule = _$AppModule();
    final settingsModule = _$SettingsModule();
    gh.factory<_i236.HomeBloc>(
      () =>
          _i236.HomeBloc(getMoviesByCategory: gh<_i494.GetMoviesByCategory>()),
    );
    gh.lazySingleton<_i733.FavoriteIdsCubit>(
      () => _i733.FavoriteIdsCubit(
        watchFavoriteIds: gh<_i494.WatchFavoriteIds>(),
        toggleFavorite: gh<_i494.ToggleFavorite>(),
      ),
    );
    gh.factory<_i508.FavoritesBloc>(
      () => _i508.FavoritesBloc(watchFavorites: gh<_i494.WatchFavorites>()),
    );
    gh.factory<_i719.SearchBloc>(
      () => _i719.SearchBloc(
        searchMovies: gh<_i494.SearchMovies>(),
        getRecentSearches: gh<_i494.GetRecentSearches>(),
        saveRecentSearch: gh<_i494.SaveRecentSearch>(),
        clearRecentSearches: gh<_i494.ClearRecentSearches>(),
      ),
    );
    gh.factoryParam<_i901.MovieDetailsBloc, int, dynamic>(
      (movieId, _) => _i901.MovieDetailsBloc(
        movieId: movieId,
        getMovieDetails: gh<_i494.GetMovieDetails>(),
        getSimilarMovies: gh<_i494.GetSimilarMovies>(),
        getMovieCredits: gh<_i494.GetMovieCredits>(),
        getMovieTrailer: gh<_i494.GetMovieTrailer>(),
        getGenres: gh<_i494.GetGenres>(),
      ),
    );
    gh.singleton<_i437.NetworkConfig>(
      () => appModule.networkConfig(gh<_i704.AppConfig>()),
    );
    await gh.singletonAsync<_i28.SettingsCubit>(
      () => settingsModule.settingsCubit(
        gh<_i494.GetSettings>(),
        gh<_i494.SaveThemeMode>(),
        gh<_i494.SaveLanguage>(),
      ),
      preResolve: true,
    );
    gh.factoryParam<_i515.MovieListBloc, _i494.MovieCategory, dynamic>(
      (category, _) => _i515.MovieListBloc(
        category: category,
        getMoviesByCategory: gh<_i494.GetMoviesByCategory>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i879.AppModule {}

class _$SettingsModule extends _i344.SettingsModule {}
