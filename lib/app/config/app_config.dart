import 'package:cine_vault/core/constants/api_endpoints.dart';
import 'package:flutter/services.dart';

enum Flavor { staging, production }

/// Build-time configuration for the current flavor.
///
/// Values come from `--dart-define-from-file=config/<flavor>.env`; the flavor
/// itself comes from `--flavor <flavor>` (exposed by Flutter as [appFlavor]).
/// [AppConfig.fromEnvironment] fails fast when the two don't match, so a
/// staging build can never silently run with production config.
///
/// Note: compile-time defines still end up in the binary. This keeps the token
/// out of the bundled assets and out of git, but it is not a secret store.
final class AppConfig {
  const AppConfig({required this.flavor, required this.tmdbBaseUrl, required this.tmdbAccessToken});

  factory AppConfig.fromEnvironment() {
    const configFlavor = String.fromEnvironment('APP_FLAVOR');
    const tmdbBaseUrl = String.fromEnvironment('TMDB_BASE_URL', defaultValue: ApiEndpoints.baseUrl);
    const tmdbAccessToken = String.fromEnvironment('TMDB_ACCESS_TOKEN');

    final flavor = Flavor.values.asNameMap()[appFlavor];
    if (flavor == null) {
      throw StateError('Unknown flavor "$appFlavor". Run with --flavor staging|production.');
    }
    if (configFlavor != flavor.name) {
      throw StateError(
        'Built with --flavor ${flavor.name} but config is for "$configFlavor". '
        'Pass --dart-define-from-file=config/${flavor.name}.env',
      );
    }
    if (tmdbAccessToken.isEmpty) {
      throw StateError('TMDB_ACCESS_TOKEN is missing in config/${flavor.name}.env');
    }

    return AppConfig(flavor: flavor, tmdbBaseUrl: tmdbBaseUrl, tmdbAccessToken: tmdbAccessToken);
  }

  final Flavor flavor;
  final String tmdbBaseUrl;
  final String tmdbAccessToken;

  /// Request/response logging is a staging-only debugging aid.
  bool get enableNetworkLogs => flavor == Flavor.staging;
}
