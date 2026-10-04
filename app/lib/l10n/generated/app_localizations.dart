import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ar'), Locale('en')];

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get tabFavorites;

  /// No description provided for @tabMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get tabMore;

  /// No description provided for @routeNotFound.
  ///
  /// In en, this message translates to:
  /// **'This page doesn\'t exist'**
  String get routeNotFound;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Shown when a value such as the release year is unknown
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @failureNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get failureNetwork;

  /// No description provided for @failureServer.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get failureServer;

  /// No description provided for @failureCache.
  ///
  /// In en, this message translates to:
  /// **'Storage error'**
  String get failureCache;

  /// No description provided for @failureUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get failureUnknown;

  /// No description provided for @categoryTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending Today'**
  String get categoryTrending;

  /// No description provided for @categoryPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get categoryPopular;

  /// No description provided for @categoryTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get categoryTopRated;

  /// No description provided for @categoryNowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get categoryNowPlaying;

  /// No description provided for @categoryUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get categoryUpcoming;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get homeSeeAll;

  /// No description provided for @homeSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get homeSearch;

  /// No description provided for @homeRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh: {reason}'**
  String homeRefreshFailed(String reason);

  /// No description provided for @detailsOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get detailsOverview;

  /// No description provided for @detailsOverviewNone.
  ///
  /// In en, this message translates to:
  /// **'No overview available.'**
  String get detailsOverviewNone;

  /// No description provided for @detailsSimilarMovies.
  ///
  /// In en, this message translates to:
  /// **'Similar Movies'**
  String get detailsSimilarMovies;

  /// No description provided for @detailsCast.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get detailsCast;

  /// No description provided for @playTrailer.
  ///
  /// In en, this message translates to:
  /// **'Play Trailer'**
  String get playTrailer;

  /// No description provided for @openInYouTube.
  ///
  /// In en, this message translates to:
  /// **'Open in YouTube'**
  String get openInYouTube;

  /// No description provided for @trailerEmbedUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This trailer can\'t be played here. Watch it on YouTube instead.'**
  String get trailerEmbedUnavailable;

  /// No description provided for @detailsVotes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 vote} other{{count} votes}}'**
  String detailsVotes(int count);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a movie...'**
  String get searchHint;

  /// No description provided for @searchRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get searchRecent;

  /// No description provided for @searchClearRecent.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClearRecent;

  /// No description provided for @searchNothingFound.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String searchNothingFound(String query);

  /// No description provided for @searchEmptyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Find any movie'**
  String get searchEmptyPrompt;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyCta.
  ///
  /// In en, this message translates to:
  /// **'Search for a movie'**
  String get favoritesEmptyCta;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @moreAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get moreAppearance;

  /// No description provided for @moreTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get moreTheme;

  /// No description provided for @moreThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get moreThemeLight;

  /// No description provided for @moreThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get moreThemeDark;

  /// No description provided for @moreLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get moreLanguage;

  /// No description provided for @moreLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get moreLanguageEnglish;

  /// No description provided for @moreLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get moreLanguageArabic;

  /// No description provided for @moreAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get moreAbout;

  /// No description provided for @moreAboutTmdb.
  ///
  /// In en, this message translates to:
  /// **'Movie data from TMDB'**
  String get moreAboutTmdb;

  /// No description provided for @moreAboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String moreAboutVersion(String version);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
