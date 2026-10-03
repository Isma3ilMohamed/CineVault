import 'package:data/src/settings/settings_local_data_source.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<SettingsLocalDataSource> dataSourceWith(Map<String, Object> stored) async {
    SharedPreferences.setMockInitialValues(stored);
    return SettingsLocalDataSourceImpl(await SharedPreferences.getInstance());
  }

  // Values written by the app before AppThemeMode existed must still load.
  test('reads settings stored by earlier versions', () async {
    final dataSource = await dataSourceWith({'theme_mode': 'light', 'locale': 'ar'});

    expect(await dataSource.getThemeMode(), AppThemeMode.light);
    expect(await dataSource.getLanguageCode(), 'ar');
  });

  test('falls back to dark and the device language when nothing is stored', () async {
    final dataSource = await dataSourceWith({});

    expect(await dataSource.getThemeMode(), AppThemeMode.dark);
    expect(await dataSource.getLanguageCode(), isNull);
  });

  test('writes the same strings it reads', () async {
    final dataSource = await dataSourceWith({'locale': 'ar'});

    await dataSource.saveThemeMode(AppThemeMode.system);
    await dataSource.saveLanguageCode(null);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme_mode'), 'system');
    expect(prefs.containsKey('locale'), isFalse);
  });
}
