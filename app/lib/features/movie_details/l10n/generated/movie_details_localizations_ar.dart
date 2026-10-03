// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'movie_details_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class MovieDetailsLocalizationsAr extends MovieDetailsLocalizations {
  MovieDetailsLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get detailsOverview => 'نبذة';

  @override
  String get detailsOverviewNone => 'مفيش نبذة متاحة.';

  @override
  String get detailsSimilarMovies => 'أفلام مشابهة';

  @override
  String get detailsCast => 'طاقم التمثيل';

  @override
  String get playTrailer => 'تشغيل العرض الدعائي';

  @override
  String get openInYouTube => 'افتح في YouTube';

  @override
  String get trailerEmbedUnavailable => 'ما يمكنش تشغيل العرض الدعائي هنا. افتحه في YouTube.';

  @override
  String detailsVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تصويت',
      many: '$count تصويت',
      few: '$count تصويتات',
      two: 'تصويتان',
      one: 'تصويت واحد',
      zero: 'لا يوجد تصويتات',
    );
    return '$_temp0';
  }
}
