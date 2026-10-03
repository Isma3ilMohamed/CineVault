import 'package:cine_vault/data/storage/storage_call.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stored newest first, de-duplicated case-insensitively, capped at 10 entries.
/// Every method throws a `CacheException` on failure.
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
  Future<List<String>> getRecentSearches() =>
      storageCall('read recent searches', () => prefs.getStringList(_key) ?? const <String>[]);

  @override
  Future<List<String>> saveRecentSearch(String query) {
    final normalized = query.trim();
    if (normalized.isEmpty) return getRecentSearches();

    return storageCall('save recent search', () async {
      final current = prefs.getStringList(_key) ?? const <String>[];
      // Drop any case-insensitive duplicate so a repeated query moves to the top.
      final updated = [
        normalized,
        ...current.where((q) => q.toLowerCase() != normalized.toLowerCase()),
      ].take(_maxItems).toList();
      await prefs.setStringList(_key, updated);
      return updated;
    });
  }

  @override
  Future<void> clearRecentSearches() =>
      storageCall('clear recent searches', () => prefs.remove(_key));
}
