// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get tabHome => 'الرئيسية';

  @override
  String get tabFavorites => 'المفضلة';

  @override
  String get tabMore => 'المزيد';

  @override
  String get routeNotFound => 'الصفحة دي مش موجودة';

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

  @override
  String get homeSeeAll => 'عرض الكل';

  @override
  String get homeSearch => 'بحث';

  @override
  String homeRefreshFailed(String reason) {
    return 'معرفناش نحدّث: $reason';
  }

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

  @override
  String get searchHint => 'ابحث عن فيلم...';

  @override
  String get searchRecent => 'عمليات البحث الأخيرة';

  @override
  String get searchClearRecent => 'مسح';

  @override
  String searchNothingFound(String query) {
    return 'مفيش نتائج لـ \"$query\"';
  }

  @override
  String get searchEmptyPrompt => 'دور على أي فيلم';

  @override
  String get favoritesTitle => 'المفضلة';

  @override
  String get favoritesEmptyTitle => 'مفيش أفلام مفضلة لسه';

  @override
  String get favoritesEmptyCta => 'ابحث عن فيلم';

  @override
  String get moreTitle => 'المزيد';

  @override
  String get moreAppearance => 'المظهر';

  @override
  String get moreTheme => 'الثيم';

  @override
  String get moreThemeLight => 'فاتح';

  @override
  String get moreThemeDark => 'داكن';

  @override
  String get moreLanguage => 'اللغة';

  @override
  String get moreLanguageEnglish => 'الإنجليزية';

  @override
  String get moreLanguageArabic => 'العربية';

  @override
  String get moreAbout => 'عن التطبيق';

  @override
  String get moreAboutTmdb => 'بيانات الأفلام من TMDB';

  @override
  String moreAboutVersion(String version) {
    return 'الإصدار $version';
  }
}
