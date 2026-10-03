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
import 'package:data/data.dart' as _i437;
import 'package:domain/domain.dart' as _i494;
import 'package:favorites/favorites.dart' as _i782;
import 'package:get_it/get_it.dart' as _i174;
import 'package:home/home.dart' as _i1024;
import 'package:injectable/injectable.dart' as _i526;
import 'package:movie_details/movie_details.dart' as _i2;
import 'package:movie_list/movie_list.dart' as _i819;
import 'package:search/search.dart' as _i838;
import 'package:settings/settings.dart' as _i133;

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
    gh.singleton<_i704.AppConfig>(() => appModule.config);
    gh.singleton<_i437.NetworkConfig>(
      () => appModule.networkConfig(gh<_i704.AppConfig>()),
    );
    await _i1024.HomePackageModule().init(gh);
    await _i819.MovieListPackageModule().init(gh);
    await _i2.MovieDetailsPackageModule().init(gh);
    await _i838.SearchPackageModule().init(gh);
    await _i782.FavoritesPackageModule().init(gh);
    await _i133.SettingsPackageModule().init(gh);
    return this;
  }
}

class _$AppModule extends _i879.AppModule {}
