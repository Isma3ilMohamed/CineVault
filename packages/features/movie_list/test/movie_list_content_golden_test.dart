import 'package:core_result/core_result.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_list/src/movie_list_content.dart';
import 'package:movie_list/src/movie_list_contract.dart';
import 'package:movie_ui/movie_ui.dart';

import 'fixtures.dart';

/// Every state in English and Arabic (RTL). Regenerate with
/// `flutter test --update-goldens`.
void main() {
  final states = <String, MovieListState>{
    'error': const MovieListState.error(ServerFailure(message: 'raw')),
    'loaded': MovieListState.loaded(
      movies: [for (var i = 1; i <= 4; i++) movie(i)],
      page: 1,
      hasReachedMax: false,
      isLoadingMore: true,
    ),
  };

  for (final locale in const [Locale('en'), Locale('ar')]) {
    for (final MapEntry(key: name, value: state) in states.entries) {
      testWidgets('$name (${locale.languageCode})', (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(_GoldenApp(locale: locale, state: state));
        // The load-more spinner never settles; one frame is enough for it.
        await tester.pump();

        await expectLater(
          find.byType(MovieListContent),
          matchesGoldenFile('goldens/${name}_${locale.languageCode}.png'),
        );
      });
    }
  }
}

class _GoldenApp extends StatelessWidget {
  const _GoldenApp({required this.locale, required this.state});

  final Locale locale;
  final MovieListState state;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: locale,
      supportedLocales: MovieUiLocalizations.supportedLocales,
      localizationsDelegates: const [
        MovieUiLocalizations.delegate,
        CoreUiLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: RemoteImageScope(
        builder: (url) => ColoredBox(color: url == null ? Colors.black : Colors.blueGrey.shade700),
        child: MovieListContent(
          category: MovieCategory.topRated,
          state: state,
          favoriteButton: (_, _, size) => Icon(Icons.favorite, size: size),
          onBack: () {},
          onRetry: () {},
          onLoadMore: () {},
          onMovieTap: (_, _) {},
        ),
      ),
    );
  }
}
