import 'package:cine_vault/core/config/app_config.dart';
import 'package:cine_vault/core/di/injection.config.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

/// The composition root. data and domain register through their injectable
/// modules; the app's own classes (features, [AppModule]) are found by the
/// generator in this package.
///
/// [config] is registered first; data and domain come next (data also opens
/// storage), then the app's own classes. Settings resolves its cubit at
/// startup, so it must come after the storage it reads from.
///
/// Call `Hive.initFlutter()` (or `Hive.init` in tests) before this. Tests pass
/// their own [config] and can replace registrations afterwards.
@InjectableInit(
  ignoreUnregisteredTypes: [AppConfig],
  externalPackageModulesBefore: [
    ExternalModule(DataPackageModule),
    ExternalModule(DomainPackageModule),
  ],
)
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
