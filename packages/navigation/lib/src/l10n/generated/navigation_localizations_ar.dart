// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'navigation_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class NavigationLocalizationsAr extends NavigationLocalizations {
  NavigationLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get tabHome => 'الرئيسية';

  @override
  String get tabFavorites => 'المفضلة';

  @override
  String get tabMore => 'المزيد';

  @override
  String get routeNotFound => 'الصفحة دي مش موجودة';
}
