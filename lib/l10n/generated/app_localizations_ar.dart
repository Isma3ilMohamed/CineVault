// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'CineVault';

  @override
  String get tryAgain => 'حاول تاني';

  @override
  String get clear => 'مسح';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String errorPrefix(String message) {
    return 'خطأ: $message';
  }

  @override
  String get sectionTrending => 'الرائج اليوم';

  @override
  String get sectionPopular => 'الأكثر شهرة';

  @override
  String get sectionTopRated => 'الأعلى تقييماً';

  @override
  String get sectionNowPlaying => 'يُعرض الآن';

  @override
  String get sectionUpcoming => 'قريباً';

  @override
  String get detailsInvalidMovieId => 'رقم فيلم غير صالح';

  @override
  String get searchHint => 'ابحث عن فيلم...';

  @override
  String get searchRecent => 'عمليات البحث الأخيرة';

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
  String get tabHome => 'الرئيسية';

  @override
  String get tabFavorites => 'المفضلة';

  @override
  String get tabMore => 'المزيد';

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
  String get moreThemeSystem => 'حسب النظام';

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
