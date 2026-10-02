import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/result/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/settings_repository.dart';

class SaveLocale implements UseCase<void, SaveLocaleParams> {
  final SettingsRepository repository;

  const SaveLocale(this.repository);

  @override
  Future<Result<void>> call(SaveLocaleParams params) {
    return repository.saveLocale(params.locale);
  }
}

class SaveLocaleParams extends Equatable {
  /// null → "follow system"
  final Locale? locale;

  const SaveLocaleParams({required this.locale});

  @override
  List<Object?> get props => [locale];
}
