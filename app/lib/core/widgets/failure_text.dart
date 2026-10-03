import 'package:cine_vault/core/l10n/generated/core_ui_localizations.dart';
import 'package:cine_vault/core/result/core_result.dart';
import 'package:flutter/widgets.dart';

/// User-facing text for a [Failure], chosen by its type (never its raw message).
extension FailureText on Failure {
  String localizedMessage(BuildContext context) {
    final l10n = CoreUiLocalizations.of(context);
    return switch (this) {
      NetworkFailure() => l10n.failureNetwork,
      ServerFailure() => l10n.failureServer,
      CacheFailure() => l10n.failureCache,
      UnknownFailure() => l10n.failureUnknown,
    };
  }
}
