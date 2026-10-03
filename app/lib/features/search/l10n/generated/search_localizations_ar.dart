// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'search_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class SearchLocalizationsAr extends SearchLocalizations {
  SearchLocalizationsAr([String locale = 'ar']) : super(locale);

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
}
