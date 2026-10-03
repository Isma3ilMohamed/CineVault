import 'package:domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('defaults to dark theme and the device language', () {
    const settings = AppSettings.defaults();
    expect(settings.themeMode, AppThemeMode.dark);
    expect(settings.languageCode, isNull);
  });

  test('copyWith changes only what is given', () {
    const settings = AppSettings(themeMode: AppThemeMode.light, languageCode: 'ar');
    expect(
      settings.copyWith(themeMode: AppThemeMode.system),
      const AppSettings(themeMode: AppThemeMode.system, languageCode: 'ar'),
    );
  });

  test('followDeviceLanguage clears the language', () {
    const settings = AppSettings(themeMode: AppThemeMode.light, languageCode: 'ar');
    expect(settings.copyWith(followDeviceLanguage: true).languageCode, isNull);
  });
}
