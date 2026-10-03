import 'package:bloc/bloc.dart';
import 'package:cine_vault/domain/domain.dart';

/// App-wide theme and language. One instance, provided above MaterialApp,
/// which rebuilds from it.
///
/// This is shared app state, not a screen's view model, so it is a Cubit over
/// the domain's [AppSettings] instead of a contract with events.
///
/// For the circular theme reveal, [setThemeMode] must be called only after the
/// old-theme snapshot overlay is shown, so the rebuild happens underneath it.
class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit({
    required this.saveThemeMode,
    required this.saveLanguage,
    required AppSettings initial,
  }) : super(initial);

  final SaveThemeMode saveThemeMode;
  final SaveLanguage saveLanguage;

  /// Loads persisted settings before runApp so the first frame already uses
  /// the saved theme and locale instead of flashing the defaults.
  static Future<SettingsCubit> create({
    required GetSettings getSettings,
    required SaveThemeMode saveThemeMode,
    required SaveLanguage saveLanguage,
  }) async {
    final result = await getSettings(const NoParams());
    return SettingsCubit(
      saveThemeMode: saveThemeMode,
      saveLanguage: saveLanguage,
      initial: result.getOrElse(() => const AppSettings.defaults()),
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (mode == state.themeMode) return;
    emit(state.copyWith(themeMode: mode));
    await saveThemeMode(SaveThemeModeParams(mode: mode));
  }

  /// A null [languageCode] follows the device language.
  Future<void> setLanguage(String? languageCode) async {
    if (languageCode == state.languageCode) return;
    emit(state.copyWith(languageCode: languageCode, followDeviceLanguage: languageCode == null));
    await saveLanguage(SaveLanguageParams(languageCode: languageCode));
  }
}
