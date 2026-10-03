import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'movie_ui_localizations_ar.dart';
import 'movie_ui_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of MovieUiLocalizations
/// returned by `MovieUiLocalizations.of(context)`.
///
/// Applications need to include `MovieUiLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/movie_ui_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: MovieUiLocalizations.localizationsDelegates,
///   supportedLocales: MovieUiLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the MovieUiLocalizations.supportedLocales
/// property.
abstract class MovieUiLocalizations {
  MovieUiLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static MovieUiLocalizations of(BuildContext context) {
    return Localizations.of<MovieUiLocalizations>(context, MovieUiLocalizations)!;
  }

  static const LocalizationsDelegate<MovieUiLocalizations> delegate =
      _MovieUiLocalizationsDelegate();

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
}

class _MovieUiLocalizationsDelegate extends LocalizationsDelegate<MovieUiLocalizations> {
  const _MovieUiLocalizationsDelegate();

  @override
  Future<MovieUiLocalizations> load(Locale locale) {
    return SynchronousFuture<MovieUiLocalizations>(lookupMovieUiLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_MovieUiLocalizationsDelegate old) => false;
}

MovieUiLocalizations lookupMovieUiLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return MovieUiLocalizationsAr();
    case 'en':
      return MovieUiLocalizationsEn();
  }

  throw FlutterError(
    'MovieUiLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
