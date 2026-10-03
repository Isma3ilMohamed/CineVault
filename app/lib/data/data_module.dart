import 'package:cine_vault/data/network/dio_client.dart';
import 'package:cine_vault/data/sources/favorites_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Third-party instances the classes above depend on.
@module
abstract class DataModule {
  @lazySingleton
  Dio dio(DioClient client) => client.dio;

  /// Opened once at startup, so the repositories can read synchronously.
  @preResolve
  @singleton
  Future<SharedPreferences> get preferences => SharedPreferences.getInstance();

  @preResolve
  @singleton
  Future<Box<dynamic>> get favoritesBox =>
      Hive.openBox<dynamic>(FavoritesLocalDataSourceImpl.boxName);
}
