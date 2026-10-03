import 'package:core_result/core_result.dart';
import 'package:domain/src/settings/app_settings.dart';
import 'package:domain/src/settings/settings_repository.dart';
import 'package:domain/src/usecase.dart';

class GetSettings implements UseCase<AppSettings, NoParams> {
  const GetSettings(this.repository);
  final SettingsRepository repository;

  @override
  Future<Result<AppSettings>> call(NoParams params) {
    return repository.getSettings();
  }
}
