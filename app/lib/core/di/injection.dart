import 'package:cine_vault/core/config/app_config.dart';
import 'package:cine_vault/core/di/injection.config.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:favorites/favorites.dart';
import 'package:get_it/get_it.dart';
import 'package:home/home.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_details/movie_details.dart';
import 'package:movie_list/movie_list.dart';
import 'package:search/search.dart';
import 'package:settings/settings.dart';

final GetIt getIt = GetIt.instance;

/// The composition root: every package registers its own classes in its
/// injectable module; this only decides the order.
///
/// [config] is registered first; data and domain come next (data also opens
/// storage), then the app's own [AppModule], then the features. Settings
/// resolves its cubit at startup, so it must come after the storage it reads
/// from.
///
/// Call `Hive.initFlutter()` (or `Hive.init` in tests) before this. Tests pass
/// their own [config] and can replace registrations afterwards.
@InjectableInit(
  ignoreUnregisteredTypes: [AppConfig],
  externalPackageModulesBefore: [
    ExternalModule(DataPackageModule),
    ExternalModule(DomainPackageModule),
  ],
  externalPackageModulesAfter: [
    ExternalModule(HomePackageModule),
    ExternalModule(MovieListPackageModule),
    ExternalModule(MovieDetailsPackageModule),
    ExternalModule(SearchPackageModule),
    ExternalModule(FavoritesPackageModule),
    ExternalModule(SettingsPackageModule),
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
