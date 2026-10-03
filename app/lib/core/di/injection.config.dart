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
import 'package:cine_vault/features/favorites/favorite_ids_cubit.dart' as _i295;
import 'package:cine_vault/features/favorites/favorites_bloc.dart' as _i1003;
import 'package:cine_vault/features/home/home_bloc.dart' as _i528;
import 'package:cine_vault/features/movie_details/movie_details_bloc.dart'
    as _i159;
import 'package:cine_vault/features/movie_list/movie_list_bloc.dart' as _i805;
import 'package:cine_vault/features/search/search_bloc.dart' as _i382;
import 'package:cine_vault/features/settings/settings_cubit.dart' as _i756;
import 'package:cine_vault/features/settings/settings_injection.dart' as _i11;
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
    gh.factory<_i528.HomeBloc>(
      () =>
          _i528.HomeBloc(getMoviesByCategory: gh<_i494.GetMoviesByCategory>()),
    );
    gh.lazySingleton<_i295.FavoriteIdsCubit>(
      () => _i295.FavoriteIdsCubit(
        watchFavoriteIds: gh<_i494.WatchFavoriteIds>(),
        toggleFavorite: gh<_i494.ToggleFavorite>(),
      ),
    );
    gh.factory<_i1003.FavoritesBloc>(
      () => _i1003.FavoritesBloc(watchFavorites: gh<_i494.WatchFavorites>()),
    );
    gh.factory<_i382.SearchBloc>(
      () => _i382.SearchBloc(
        searchMovies: gh<_i494.SearchMovies>(),
        getRecentSearches: gh<_i494.GetRecentSearches>(),
        saveRecentSearch: gh<_i494.SaveRecentSearch>(),
        clearRecentSearches: gh<_i494.ClearRecentSearches>(),
      ),
    );
    gh.factoryParam<_i159.MovieDetailsBloc, int, dynamic>(
      (movieId, _) => _i159.MovieDetailsBloc(
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
    await gh.singletonAsync<_i756.SettingsCubit>(
      () => settingsModule.settingsCubit(
        gh<_i494.GetSettings>(),
        gh<_i494.SaveThemeMode>(),
        gh<_i494.SaveLanguage>(),
      ),
      preResolve: true,
    );
    gh.factoryParam<_i805.MovieListBloc, _i494.MovieCategory, dynamic>(
      (category, _) => _i805.MovieListBloc(
        category: category,
        getMoviesByCategory: gh<_i494.GetMoviesByCategory>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i879.AppModule {}

class _$SettingsModule extends _i11.SettingsModule {}
