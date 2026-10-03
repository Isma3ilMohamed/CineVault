// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'search_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SearchLocalizationsEn extends SearchLocalizations {
  SearchLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get searchHint => 'Search for a movie...';

  @override
  String get searchRecent => 'Recent searches';

  @override
  String get searchClearRecent => 'Clear';

  @override
  String searchNothingFound(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get searchEmptyPrompt => 'Find any movie';
}
