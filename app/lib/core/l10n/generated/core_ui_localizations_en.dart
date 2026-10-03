// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'core_ui_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class CoreUiLocalizationsEn extends CoreUiLocalizations {
  CoreUiLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tryAgain => 'Try again';

  @override
  String get back => 'Back';

  @override
  String get notAvailable => 'N/A';

  @override
  String get failureNetwork => 'No internet connection';

  @override
  String get failureServer => 'Server error';

  @override
  String get failureCache => 'Storage error';

  @override
  String get failureUnknown => 'Something went wrong';
}
