// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'home_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class HomeLocalizationsEn extends HomeLocalizations {
  HomeLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeSeeAll => 'See All';

  @override
  String get homeSearch => 'Search';

  @override
  String homeRefreshFailed(String reason) {
    return 'Couldn\'t refresh: $reason';
  }
}
