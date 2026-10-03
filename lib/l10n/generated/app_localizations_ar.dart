// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String errorPrefix(String message) {
    return 'خطأ: $message';
  }

  @override
  String get detailsInvalidMovieId => 'رقم فيلم غير صالح';

  @override
  String get invalidCategory => 'قسم غير صالح';

  @override
  String get tabHome => 'الرئيسية';

  @override
  String get tabFavorites => 'المفضلة';

  @override
  String get tabMore => 'المزيد';
}
