// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:data/src/data_injection.dart' as _i159;
import 'package:data/src/favorites/favorites_local_data_source.dart' as _i1007;
import 'package:data/src/favorites/favorites_repository_impl.dart' as _i19;
import 'package:data/src/movies/movie_remote_data_source.dart' as _i168;
import 'package:data/src/movies/movie_repository_impl.dart' as _i467;
import 'package:data/src/network/dio_client.dart' as _i635;
import 'package:data/src/network/network_config.dart' as _i1041;
import 'package:data/src/search/recent_searches_local_data_source.dart' as _i146;
import 'package:data/src/search/search_remote_data_source.dart' as _i620;
import 'package:data/src/search/search_repository_impl.dart' as _i322;
import 'package:data/src/settings/settings_local_data_source.dart' as _i279;
import 'package:data/src/settings/settings_repository_impl.dart' as _i643;
import 'package:dio/dio.dart' as _i361;
import 'package:domain/domain.dart' as _i494;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

class DataPackageModule extends _i526.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final dataModule = _$DataModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => dataModule.preferences,
      preResolve: true,
    );
    await gh.singletonAsync<_i979.Box<dynamic>>(() => dataModule.favoritesBox, preResolve: true);
    gh.lazySingleton<_i1007.FavoritesLocalDataSource>(
      () => _i1007.FavoritesLocalDataSourceImpl(gh<_i979.Box<dynamic>>()),
    );
    gh.lazySingleton<_i146.RecentSearchesLocalDataSource>(
      () => _i146.RecentSearchesLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i494.FavoritesRepository>(
      () => _i19.FavoritesRepositoryImpl(localDataSource: gh<_i1007.FavoritesLocalDataSource>()),
    );
    gh.lazySingleton<_i635.DioClient>(() => _i635.DioClient(gh<_i1041.NetworkConfig>()));
    gh.lazySingleton<_i279.SettingsLocalDataSource>(
      () => _i279.SettingsLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i361.Dio>(() => dataModule.dio(gh<_i635.DioClient>()));
    gh.lazySingleton<_i494.SettingsRepository>(
      () => _i643.SettingsRepositoryImpl(localDataSource: gh<_i279.SettingsLocalDataSource>()),
    );
    gh.lazySingleton<_i620.SearchRemoteDataSource>(
      () => _i620.SearchRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i168.MovieRemoteDataSource>(
      () => _i168.MovieRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i494.SearchRepository>(
      () => _i322.SearchRepositoryImpl(
        remoteDataSource: gh<_i620.SearchRemoteDataSource>(),
        localDataSource: gh<_i146.RecentSearchesLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i494.MovieRepository>(
      () => _i467.MovieRepositoryImpl(remoteDataSource: gh<_i168.MovieRemoteDataSource>()),
    );
  }
}

class _$DataModule extends _i159.DataModule {}
