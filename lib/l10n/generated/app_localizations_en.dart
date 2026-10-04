// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabHome => 'Home';

  @override
  String get tabFavorites => 'Favorites';

  @override
  String get tabMore => 'More';

  @override
  String get routeNotFound => 'This page doesn\'t exist';

  @override
  String get tryAgain => 'Try again';

  @override
  String get back => 'Back';

  @override
  String get notAvailable => 'N/A';

  @override
  String get failureNetwork => 'No internet connection';

  @override
  String get failureServer => 'Server error';

  @override
  String get failureCache => 'Storage error';

  @override
  String get failureUnknown => 'Something went wrong';

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

  @override
  String get homeSeeAll => 'See All';

  @override
  String get homeSearch => 'Search';

  @override
  String homeRefreshFailed(String reason) {
    return 'Couldn\'t refresh: $reason';
  }

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

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmptyTitle => 'No favorites yet';

  @override
  String get favoritesEmptyCta => 'Search for a movie';

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
}
