import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/save_locale.dart';
import '../../domain/usecases/save_theme_mode.dart';

/// For the circular theme reveal, [setThemeMode] must be called only after the
/// old-theme snapshot overlay is shown, so the rebuild happens underneath it.
class SettingsCubit extends Cubit<AppSettings> {
  final GetSettings getSettingsUseCase;
  final SaveThemeMode saveThemeModeUseCase;
  final SaveLocale saveLocaleUseCase;

  SettingsCubit({
    required this.getSettingsUseCase,
    required this.saveThemeModeUseCase,
    required this.saveLocaleUseCase,
    required AppSettings initial,
  }) : super(initial);

  /// Loads persisted settings before runApp so the first frame already uses
  /// the saved theme and locale instead of flashing the defaults.
  static Future<SettingsCubit> create({
    required GetSettings getSettings,
    required SaveThemeMode saveThemeMode,
    required SaveLocale saveLocale,
  }) async {
    final result = await getSettings(const NoParams());
    final initial = result.getOrElse(() => const AppSettings.defaults());
    return SettingsCubit(
      getSettingsUseCase: getSettings,
      saveThemeModeUseCase: saveThemeMode,
      saveLocaleUseCase: saveLocale,
      initial: initial,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == state.themeMode) return;
    emit(state.copyWith(themeMode: mode));
    await saveThemeModeUseCase(SaveThemeModeParams(mode: mode));
  }

  Future<void> setLocale(Locale? locale) async {
    if (locale == state.locale) return;
    emit(state.copyWith(locale: locale, clearLocale: locale == null));
    await saveLocaleUseCase(SaveLocaleParams(locale: locale));
  }
}
