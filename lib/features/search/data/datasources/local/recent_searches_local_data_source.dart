import 'package:cine_vault/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stored newest first, de-duplicated case-insensitively, capped at 10 entries.
abstract class RecentSearchesLocalDataSource {
  Future<List<String>> getRecentSearches();

  Future<List<String>> saveRecentSearch(String query);

  Future<void> clearRecentSearches();
}

class RecentSearchesLocalDataSourceImpl implements RecentSearchesLocalDataSource {
  RecentSearchesLocalDataSourceImpl(this.prefs);
  static const String _key = 'recent_searches';
  static const int _maxItems = 10;

  final SharedPreferences prefs;

  @override
  Future<List<String>> getRecentSearches() async {
    try {
      return prefs.getStringList(_key) ?? const <String>[];
    } catch (e) {
      throw CacheException(message: 'Failed to read recent searches: $e');
    }
  }

  @override
  Future<List<String>> saveRecentSearch(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return await getRecentSearches();
    }

    try {
      final current = prefs.getStringList(_key) ?? const <String>[];

      // Drop any case-insensitive duplicate so a repeated query moves to the top.
      final filtered = current.where((q) => q.toLowerCase() != normalized.toLowerCase()).toList();

      final updated = <String>[normalized, ...filtered];
      final trimmed = updated.length > _maxItems ? updated.sublist(0, _maxItems) : updated;

      await prefs.setStringList(_key, trimmed);
      return trimmed;
    } catch (e) {
      throw CacheException(message: 'Failed to save recent search: $e');
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    try {
      await prefs.remove(_key);
    } catch (e) {
      throw CacheException(message: 'Failed to clear recent searches: $e');
    }
  }
}
