import 'package:core_result/core_result.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ui/movie_ui.dart';
import 'package:search/search.dart';
import 'package:search/src/search_content.dart';
import 'package:search/src/search_contract.dart';

import 'fixtures.dart';

/// Every state in English and Arabic (RTL). Regenerate with
/// `flutter test --update-goldens`.
void main() {
  final states = <String, SearchState>{
    'prompt': const SearchState.idle(),
    'recents': const SearchState.idle(recentSearches: ['Inception', 'Batman']),
    'loaded': SearchState.loaded(
      query: 'movie',
      results: [movie(1), movie(2)],
      page: 1,
      hasReachedMax: false,
    ),
    'empty': const SearchState.empty(query: 'zzz'),
    'error': const SearchState.error(query: 'movie', failure: NetworkFailure()),
  };

  for (final locale in const [Locale('en'), Locale('ar')]) {
    for (final MapEntry(key: name, value: state) in states.entries) {
      testWidgets('$name (${locale.languageCode})', (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(_GoldenApp(locale: locale, state: state));

        await expectLater(
          find.byType(SearchContent),
          matchesGoldenFile('goldens/${name}_${locale.languageCode}.png'),
        );
      });
    }
  }
}

class _GoldenApp extends StatelessWidget {
  const _GoldenApp({required this.locale, required this.state});

  final Locale locale;
  final SearchState state;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: locale,
      supportedLocales: SearchLocalizations.supportedLocales,
      localizationsDelegates: const [
        SearchLocalizations.delegate,
        MovieUiLocalizations.delegate,
        CoreUiLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: RemoteImageScope(
        builder: (url) => ColoredBox(color: url == null ? Colors.black : Colors.blueGrey.shade700),
        child: SearchContent(
          state: state,
          favoriteButton: (_, _, size) => Icon(Icons.favorite, size: size),
          onBack: () {},
          onQueryChanged: (_) {},
          onCleared: () {},
          onRecentTap: (_) {},
          onClearRecents: () {},
          onRetry: () {},
          onLoadMore: () {},
          onMovieTap: (_, _) {},
        ),
      ),
    );
  }
}
