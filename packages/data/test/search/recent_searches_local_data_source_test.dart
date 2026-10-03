import 'package:data/src/search/recent_searches_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<RecentSearchesLocalDataSource> dataSource([Map<String, Object> stored = const {}]) async {
    SharedPreferences.setMockInitialValues(stored);
    return RecentSearchesLocalDataSourceImpl(await SharedPreferences.getInstance());
  }

  test('puts the newest query first', () async {
    final source = await dataSource({
      'recent_searches': ['alien'],
    });
    expect(await source.saveRecentSearch('dune'), ['dune', 'alien']);
  });

  test('a repeated query moves to the top, case-insensitively', () async {
    final source = await dataSource({
      'recent_searches': ['dune', 'alien'],
    });
    expect(await source.saveRecentSearch('ALIEN'), ['ALIEN', 'dune']);
  });

  test('keeps at most 10 entries', () async {
    final source = await dataSource({
      'recent_searches': [for (var i = 0; i < 10; i++) 'q$i'],
    });
    final saved = await source.saveRecentSearch('new');
    expect(saved, hasLength(10));
    expect(saved.first, 'new');
    expect(saved, isNot(contains('q9')));
  });

  test('ignores blank queries', () async {
    final source = await dataSource({
      'recent_searches': ['dune'],
    });
    expect(await source.saveRecentSearch('  '), ['dune']);
  });
}
