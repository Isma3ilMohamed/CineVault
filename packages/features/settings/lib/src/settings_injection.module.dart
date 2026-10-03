// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:domain/domain.dart' as _i494;
import 'package:injectable/injectable.dart' as _i526;
import 'package:settings/src/settings_cubit.dart' as _i228;
import 'package:settings/src/settings_injection.dart' as _i125;

class SettingsPackageModule extends _i526.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final settingsModule = _$SettingsModule();
    await gh.singletonAsync<_i228.SettingsCubit>(
      () => settingsModule.settingsCubit(
        gh<_i494.GetSettings>(),
        gh<_i494.SaveThemeMode>(),
        gh<_i494.SaveLanguage>(),
      ),
      preResolve: true,
    );
  }
}

class _$SettingsModule extends _i125.SettingsModule {}
