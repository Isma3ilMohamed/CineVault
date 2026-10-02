import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/save_locale.dart';
import '../../domain/usecases/save_theme_mode.dart';

/// ببساطة كدا: global cubit بيحتفظ بـ AppSettings (theme + locale)
/// - Lives at app root → MaterialApp بيقرا منه themeMode و locale
/// - Persist بعد كل تغيير عن طريق save* use cases
///
/// Order of operations مهم لـ circular reveal:
///   1. UI calls `setThemeMode(...)` AFTER animation starts
///   2. Emit → MaterialApp rebuilds with new theme underneath
///   3. Overlay (old theme screenshot) animates الـ clip circle
///   4. Overlay ينتهي → removed
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

  /// Factory بيعمل cubit بعد ما يقرا الـ initial settings من الـ storage
  /// بنستخدمه في main() قبل ما المـ MaterialApp يشتغل
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
