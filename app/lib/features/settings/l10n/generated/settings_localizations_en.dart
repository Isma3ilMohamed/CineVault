// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'settings_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SettingsLocalizationsEn extends SettingsLocalizations {
  SettingsLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get moreTitle => 'More';

  @override
  String get moreAppearance => 'Appearance';

  @override
  String get moreTheme => 'Theme';

  @override
  String get moreThemeLight => 'Light';

  @override
  String get moreThemeDark => 'Dark';

  @override
  String get moreLanguage => 'Language';

  @override
  String get moreLanguageEnglish => 'English';

  @override
  String get moreLanguageArabic => 'Arabic';

  @override
  String get moreAbout => 'About';

  @override
  String get moreAboutTmdb => 'Movie data from TMDB';

  @override
  String moreAboutVersion(String version) {
    return 'Version $version';
  }
}
