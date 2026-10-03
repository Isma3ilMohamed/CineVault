// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'core_ui_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class CoreUiLocalizationsAr extends CoreUiLocalizations {
  CoreUiLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get tryAgain => 'حاول تاني';

  @override
  String get back => 'رجوع';

  @override
  String get notAvailable => 'غير معروف';

  @override
  String get failureNetwork => 'مفيش اتصال بالإنترنت';

  @override
  String get failureServer => 'خطأ في الخادم';

  @override
  String get failureCache => 'خطأ في التخزين';

  @override
  String get failureUnknown => 'حصل خطأ غير متوقع';
}
