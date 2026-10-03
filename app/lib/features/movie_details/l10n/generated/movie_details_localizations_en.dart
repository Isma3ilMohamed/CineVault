// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'movie_details_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class MovieDetailsLocalizationsEn extends MovieDetailsLocalizations {
  MovieDetailsLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get detailsOverview => 'Overview';

  @override
  String get detailsOverviewNone => 'No overview available.';

  @override
  String get detailsSimilarMovies => 'Similar Movies';

  @override
  String get detailsCast => 'Cast';

  @override
  String get playTrailer => 'Play Trailer';

  @override
  String get openInYouTube => 'Open in YouTube';

  @override
  String get trailerEmbedUnavailable =>
      'This trailer can\'t be played here. Watch it on YouTube instead.';

  @override
  String detailsVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count votes',
      one: '1 vote',
    );
    return '$_temp0';
  }
}
