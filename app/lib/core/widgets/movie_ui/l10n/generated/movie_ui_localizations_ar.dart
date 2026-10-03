// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'movie_ui_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class MovieUiLocalizationsAr extends MovieUiLocalizations {
  MovieUiLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get categoryTrending => 'الرائج اليوم';

  @override
  String get categoryPopular => 'الأكثر شهرة';

  @override
  String get categoryTopRated => 'الأعلى تقييماً';

  @override
  String get categoryNowPlaying => 'يُعرض الآن';

  @override
  String get categoryUpcoming => 'قريباً';
}
