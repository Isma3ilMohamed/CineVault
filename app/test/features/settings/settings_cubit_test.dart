import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/data/repositories/settings_repository.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late _MockSettingsRepository repository;

  setUpAll(() => registerFallbackValue(AppThemeMode.dark));

  setUp(() {
    repository = _MockSettingsRepository();
    when(() => repository.saveThemeMode(any())).thenAnswer((_) async => const Ok(null));
    when(() => repository.saveLanguageCode(any())).thenAnswer((_) async => const Ok(null));
  });

  Future<SettingsCubit> create() => SettingsCubit.create(settingsRepository: repository);

  test('create starts from the saved settings, or the defaults if they fail', () async {
    when(() => repository.getSettings()).thenAnswer(
      (_) async => const Ok(AppSettings(themeMode: AppThemeMode.light, languageCode: 'ar')),
    );
    expect((await create()).state.languageCode, 'ar');

    when(() => repository.getSettings())
        .thenAnswer((_) async => const Err(CacheFailure(message: 'corrupt')));
    expect((await create()).state, const AppSettings.defaults());
  });

  test('setThemeMode updates and saves, and skips saving the same mode', () async {
    when(() => repository.getSettings()).thenAnswer((_) async => const Ok(AppSettings.defaults()));
    final cubit = await create();

    await cubit.setThemeMode(AppThemeMode.light);
    await cubit.setThemeMode(AppThemeMode.light);

    expect(cubit.state.themeMode, AppThemeMode.light);
    verify(() => repository.saveThemeMode(AppThemeMode.light)).called(1);
  });

  test('setLanguage(null) follows the device language', () async {
    when(() => repository.getSettings()).thenAnswer(
      (_) async => const Ok(AppSettings(themeMode: AppThemeMode.dark, languageCode: 'ar')),
    );
    final cubit = await create();

    await cubit.setLanguage(null);

    expect(cubit.state.languageCode, isNull);
    verify(() => repository.saveLanguageCode(null)).called(1);
  });
}
