// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'favorites_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class FavoritesLocalizationsEn extends FavoritesLocalizations {
  FavoritesLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmptyTitle => 'No favorites yet';

  @override
  String get favoritesEmptyCta => 'Search for a movie';
}
