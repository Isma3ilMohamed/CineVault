// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'navigation_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class NavigationLocalizationsEn extends NavigationLocalizations {
  NavigationLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabHome => 'Home';

  @override
  String get tabFavorites => 'Favorites';

  @override
  String get tabMore => 'More';

  @override
  String get routeNotFound => 'This page doesn\'t exist';
}
