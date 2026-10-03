import 'package:data/src/favorites/favorites_local_data_source.dart';
import 'package:data/src/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Entry point of this package's injectable module: repositories, data
/// sources and the HTTP client. The app's root injector includes the
/// generated module.
///
/// Before it runs, the app must register a `NetworkConfig` and initialize
/// Hive (`Hive.initFlutter()`), since storage is opened here.
@InjectableInit.microPackage()
void initDataPackage() {}

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
