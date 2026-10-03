import 'package:core_result/core_result.dart';
import 'package:domain/src/settings/settings_repository.dart';
import 'package:domain/src/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveLanguage implements UseCase<void, SaveLanguageParams> {
  const SaveLanguage(this.repository);
  final SettingsRepository repository;

  @override
  Future<Result<void>> call(SaveLanguageParams params) {
    return repository.saveLanguageCode(params.languageCode);
  }
}

class SaveLanguageParams extends Equatable {
  const SaveLanguageParams({required this.languageCode});

  /// A null code means follow the device language.
  final String? languageCode;

  @override
  List<Object?> get props => [languageCode];
}
