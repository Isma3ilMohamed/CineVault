// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'home_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class HomeLocalizationsAr extends HomeLocalizations {
  HomeLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get homeSeeAll => 'عرض الكل';

  @override
  String get homeSearch => 'بحث';

  @override
  String homeRefreshFailed(String reason) {
    return 'معرفناش نحدّث: $reason';
  }
}
