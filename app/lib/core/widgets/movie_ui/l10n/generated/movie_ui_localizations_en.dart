// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'movie_ui_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class MovieUiLocalizationsEn extends MovieUiLocalizations {
  MovieUiLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get categoryTrending => 'Trending Today';

  @override
  String get categoryPopular => 'Popular';

  @override
  String get categoryTopRated => 'Top Rated';

  @override
  String get categoryNowPlaying => 'Now Playing';

  @override
  String get categoryUpcoming => 'Upcoming';
}
