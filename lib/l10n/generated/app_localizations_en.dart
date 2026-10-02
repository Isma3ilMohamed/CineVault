// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CineVault';

  @override
  String get tryAgain => 'Try again';

  @override
  String get back => 'Back';

  @override
  String get clear => 'Clear';

  @override
  String get seeAll => 'See All';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get sectionTrending => 'Trending Today';

  @override
  String get sectionPopular => 'Popular';

  @override
  String get sectionTopRated => 'Top Rated';

  @override
  String get sectionNowPlaying => 'Now Playing';

  @override
  String get sectionUpcoming => 'Upcoming';

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
  String get detailsInvalidMovieId => 'Invalid movie id';

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

  @override
  String get searchHint => 'Search for a movie...';

  @override
  String get searchRecent => 'Recent searches';

  @override
  String searchNothingFound(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get searchEmptyPrompt => 'Find any movie';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmptyTitle => 'No favorites yet';

  @override
  String get favoritesEmptyCta => 'Search for a movie';

  @override
  String get tabHome => 'Home';

  @override
  String get tabFavorites => 'Favorites';

  @override
  String get tabMore => 'More';

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
  String get moreThemeSystem => 'System';

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

  @override
  String get failureNetwork => 'No internet connection';

  @override
  String get failureServer => 'Server error';

  @override
  String get failureUnknown => 'Something went wrong';

  @override
  String get failureCache => 'Storage error';
}
