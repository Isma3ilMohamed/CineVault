/// Names under which data is stored on the device. Changing a value orphans
/// what users already saved under the old one.
abstract final class StorageKeys {
  /// Hive box with the favorite movies.
  static const String favoritesBox = 'favorites';

  /// Field added to each stored favorite to keep them in the order added.
  static const String favoriteAddedAt = '_added_at';

  /// SharedPreferences keys.
  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String recentSearches = 'recent_searches';
}
