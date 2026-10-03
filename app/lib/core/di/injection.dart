import 'package:cine_vault/core/config/app_config.dart';
import 'package:cine_vault/core/di/injection.config.dart';
import 'package:cine_vault/data/network/network_config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

/// The composition root: the generator finds every annotated class in the app
/// and registers it. [config] is registered first.
///
/// Call `Hive.initFlutter()` (or `Hive.init` in tests) before this. Tests pass
/// their own [config] and can replace registrations afterwards.
@InjectableInit(ignoreUnregisteredTypes: [AppConfig])
Future<void> configureDependencies(AppConfig config) async {
  getIt.registerSingleton(config);
  await getIt.init();
}

/// What only the app knows: turns the flavor's build config into what the
/// packages need.
@module
abstract class AppModule {
  @singleton
  NetworkConfig networkConfig(AppConfig config) => NetworkConfig(
    baseUrl: config.tmdbBaseUrl,
    accessToken: config.tmdbAccessToken,
    enableNetworkLogs: config.enableNetworkLogs,
  );
}
