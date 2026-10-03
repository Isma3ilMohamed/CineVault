import 'package:get_it/get_it.dart';
import 'package:settings/src/settings_cubit.dart';

/// Registers the app-wide [SettingsCubit]. Async because it reads the saved
/// settings first. The use cases must already be registered.
Future<void> registerSettingsDependencies(GetIt getIt) async {
  final cubit = await SettingsCubit.create(
    getSettings: getIt(),
    saveThemeMode: getIt(),
    saveLanguage: getIt(),
  );
  getIt.registerSingleton(cubit);
}
