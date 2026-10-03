import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/src/settings_cubit.dart';

/// Entry point of this package's injectable module: the app-wide
/// SettingsCubit. The app's root injector includes the generated module; the
/// use cases come from `domain`.
@InjectableInit.microPackage()
void initSettingsPackage() {}

@module
abstract class SettingsModule {
  /// Resolved at startup, so the first frame already uses the saved theme and
  /// locale instead of flashing the defaults.
  @preResolve
  @singleton
  Future<SettingsCubit> settingsCubit(
    GetSettings getSettings,
    SaveThemeMode saveThemeMode,
    SaveLanguage saveLanguage,
  ) => SettingsCubit.create(
    getSettings: getSettings,
    saveThemeMode: saveThemeMode,
    saveLanguage: saveLanguage,
  );
}
