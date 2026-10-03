import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'movie_details_localizations_ar.dart';
import 'movie_details_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of MovieDetailsLocalizations
/// returned by `MovieDetailsLocalizations.of(context)`.
///
/// Applications need to include `MovieDetailsLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/movie_details_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: MovieDetailsLocalizations.localizationsDelegates,
///   supportedLocales: MovieDetailsLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the MovieDetailsLocalizations.supportedLocales
/// property.
abstract class MovieDetailsLocalizations {
  MovieDetailsLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static MovieDetailsLocalizations of(BuildContext context) {
    return Localizations.of<MovieDetailsLocalizations>(context, MovieDetailsLocalizations)!;
  }

  static const LocalizationsDelegate<MovieDetailsLocalizations> delegate =
      _MovieDetailsLocalizationsDelegate();

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
}

class _MovieDetailsLocalizationsDelegate extends LocalizationsDelegate<MovieDetailsLocalizations> {
  const _MovieDetailsLocalizationsDelegate();

  @override
  Future<MovieDetailsLocalizations> load(Locale locale) {
    return SynchronousFuture<MovieDetailsLocalizations>(lookupMovieDetailsLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_MovieDetailsLocalizationsDelegate old) => false;
}

MovieDetailsLocalizations lookupMovieDetailsLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return MovieDetailsLocalizationsAr();
    case 'en':
      return MovieDetailsLocalizationsEn();
  }

  throw FlutterError(
    'MovieDetailsLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
