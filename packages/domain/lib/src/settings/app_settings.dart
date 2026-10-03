import 'package:equatable/equatable.dart';

/// Theme preference, independent of Flutter's `ThemeMode`.
enum AppThemeMode { system, light, dark }

class AppSettings extends Equatable {
  const AppSettings({required this.themeMode, this.languageCode});

  const AppSettings.defaults() : themeMode = AppThemeMode.dark, languageCode = null;

  final AppThemeMode themeMode;

  /// ISO 639-1 code such as 'en' or 'ar'; null follows the device language.
  final String? languageCode;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    String? languageCode,
    bool followDeviceLanguage = false,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      languageCode: followDeviceLanguage ? null : (languageCode ?? this.languageCode),
    );
  }

  @override
  List<Object?> get props => [themeMode, languageCode];
}
