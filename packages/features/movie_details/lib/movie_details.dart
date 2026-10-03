/// Movie details feature. Exposes only what the app needs to place it:
/// the Route, its favorite-button slot type, the DI registration and the
/// localizations delegate.
library;

export 'src/l10n/generated/movie_details_localizations.dart';
export 'src/movie_details_content.dart' show FavoriteButtonBuilder;
export 'src/movie_details_dependencies.dart';
export 'src/movie_details_route.dart';
