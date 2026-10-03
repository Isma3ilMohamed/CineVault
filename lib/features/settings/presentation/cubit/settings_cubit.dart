import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// For the circular theme reveal, [setThemeMode] must be called only after the
/// old-theme snapshot overlay is shown, so the rebuild happens underneath it.
class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit({
    required this.getSettingsUseCase,
    required this.saveThemeModeUseCase,
    required this.saveLanguageUseCase,
    required AppSettings initial,
  }) : super(initial);
  final GetSettings getSettingsUseCase;
  final SaveThemeMode saveThemeModeUseCase;
  final SaveLanguage saveLanguageUseCase;

  /// Loads persisted settings before runApp so the first frame already uses
  /// the saved theme and locale instead of flashing the defaults.
  static Future<SettingsCubit> create({
    required GetSettings getSettings,
    required SaveThemeMode saveThemeMode,
    required SaveLanguage saveLanguage,
  }) async {
    final result = await getSettings(const NoParams());
    final initial = result.getOrElse(() => const AppSettings.defaults());
    return SettingsCubit(
      getSettingsUseCase: getSettings,
      saveThemeModeUseCase: saveThemeMode,
      saveLanguageUseCase: saveLanguage,
      initial: initial,
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (mode == state.themeMode) return;
    emit(state.copyWith(themeMode: mode));
    await saveThemeModeUseCase(SaveThemeModeParams(mode: mode));
  }

  /// A null [languageCode] follows the device language.
  Future<void> setLanguage(String? languageCode) async {
    if (languageCode == state.languageCode) return;
    emit(state.copyWith(languageCode: languageCode, followDeviceLanguage: languageCode == null));
    await saveLanguageUseCase(SaveLanguageParams(languageCode: languageCode));
  }
}
