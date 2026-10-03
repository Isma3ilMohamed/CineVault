// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'settings_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class SettingsLocalizationsAr extends SettingsLocalizations {
  SettingsLocalizationsAr([String locale = 'ar']) : super(locale);

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
