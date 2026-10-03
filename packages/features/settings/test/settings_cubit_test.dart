import 'package:core_result/core_result.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings/settings.dart';

class _MockGetSettings extends Mock implements GetSettings {}

class _MockSaveThemeMode extends Mock implements SaveThemeMode {}

class _MockSaveLanguage extends Mock implements SaveLanguage {}

void main() {
  late _MockGetSettings getSettings;
  late _MockSaveThemeMode saveThemeMode;
  late _MockSaveLanguage saveLanguage;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(const SaveThemeModeParams(mode: AppThemeMode.dark));
    registerFallbackValue(const SaveLanguageParams(languageCode: null));
  });

  setUp(() {
    getSettings = _MockGetSettings();
    saveThemeMode = _MockSaveThemeMode();
    saveLanguage = _MockSaveLanguage();
    when(() => saveThemeMode(any())).thenAnswer((_) async => const Ok(null));
    when(() => saveLanguage(any())).thenAnswer((_) async => const Ok(null));
  });

  Future<SettingsCubit> create() => SettingsCubit.create(
    getSettings: getSettings,
    saveThemeMode: saveThemeMode,
    saveLanguage: saveLanguage,
  );

  test('create starts from the saved settings, or the defaults if they fail', () async {
    when(() => getSettings(any())).thenAnswer(
      (_) async => const Ok(AppSettings(themeMode: AppThemeMode.light, languageCode: 'ar')),
    );
    expect((await create()).state.languageCode, 'ar');

    when(() => getSettings(any()))
        .thenAnswer((_) async => const Err(CacheFailure(message: 'corrupt')));
    expect((await create()).state, const AppSettings.defaults());
  });

  test('setThemeMode updates and saves, and skips saving the same mode', () async {
    when(() => getSettings(any())).thenAnswer((_) async => const Ok(AppSettings.defaults()));
    final cubit = await create();

    await cubit.setThemeMode(AppThemeMode.light);
    await cubit.setThemeMode(AppThemeMode.light);

    expect(cubit.state.themeMode, AppThemeMode.light);
    verify(() => saveThemeMode(const SaveThemeModeParams(mode: AppThemeMode.light))).called(1);
  });

  test('setLanguage(null) follows the device language', () async {
    when(() => getSettings(any())).thenAnswer(
      (_) async => const Ok(AppSettings(themeMode: AppThemeMode.dark, languageCode: 'ar')),
    );
    final cubit = await create();

    await cubit.setLanguage(null);

    expect(cubit.state.languageCode, isNull);
    verify(() => saveLanguage(const SaveLanguageParams(languageCode: null))).called(1);
  });
}
