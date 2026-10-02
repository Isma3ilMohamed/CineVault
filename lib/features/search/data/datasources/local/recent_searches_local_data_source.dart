import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/error/exceptions.dart';

/// ببساطة كدا: الـ local store للـ recent searches
/// بنخزن آخر N queries في shared_preferences كـ `List<String>`
/// - newest first
/// - dedupe case-insensitive
/// - max 10 entries
abstract class RecentSearchesLocalDataSource {
  Future<List<String>> getRecentSearches();

  /// بيضيف query ويرجع الـ list الجديدة (newest first, max 10)
  Future<List<String>> saveRecentSearch(String query);

  Future<void> clearRecentSearches();
}

class RecentSearchesLocalDataSourceImpl
    implements RecentSearchesLocalDataSource {
  static const String _key = 'recent_searches';
  static const int _maxItems = 10;

  final SharedPreferences prefs;

  RecentSearchesLocalDataSourceImpl(this.prefs);

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
      return getRecentSearches();
    }

    try {
      final current = prefs.getStringList(_key) ?? const <String>[];

      // dedupe case-insensitive — نشيل أي occurrence قديم وبعدين نضيف في الأول
      final filtered = current
          .where((q) => q.toLowerCase() != normalized.toLowerCase())
          .toList();

      final updated = <String>[normalized, ...filtered];
      final trimmed = updated.length > _maxItems
          ? updated.sublist(0, _maxItems)
          : updated;

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
