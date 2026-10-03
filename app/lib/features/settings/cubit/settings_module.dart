import 'package:cine_vault/data/repositories/settings_repository.dart';
import 'package:cine_vault/features/settings/cubit/settings_cubit.dart';
import 'package:injectable/injectable.dart';

/// Provides the app-wide SettingsCubit; picked up by the app's injector.
@module
abstract class SettingsModule {
  /// Resolved at startup, so the first frame already uses the saved theme and
  /// locale instead of flashing the defaults.
  @preResolve
  @singleton
  Future<SettingsCubit> settingsCubit(SettingsRepository settingsRepository) =>
      SettingsCubit.create(settingsRepository: settingsRepository);
}
