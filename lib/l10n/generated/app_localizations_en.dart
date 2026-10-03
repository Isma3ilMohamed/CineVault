// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get detailsInvalidMovieId => 'Invalid movie id';

  @override
  String get invalidCategory => 'Invalid category';

  @override
  String get tabHome => 'Home';

  @override
  String get tabFavorites => 'Favorites';

  @override
  String get tabMore => 'More';
}
