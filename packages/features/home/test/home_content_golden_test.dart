import 'package:core_result/core_result.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:home/src/home_content.dart';
import 'package:home/src/home_contract.dart';
import 'package:movie_ui/movie_ui.dart';

import 'fixtures.dart';

/// Every state in English and Arabic (RTL). Regenerate with
/// `flutter test --update-goldens`.
void main() {
  final states = <String, HomeState>{
    'error': const HomeState.error(NetworkFailure()),
    'loaded': HomeState.loaded(
      sections: {
        for (final category in MovieCategory.values) category: [movie(1), movie(2), movie(3)],
      },
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

        await expectLater(
          find.byType(HomeContent),
          matchesGoldenFile('goldens/${name}_${locale.languageCode}.png'),
        );
      });
    }
  }
}

class _GoldenApp extends StatelessWidget {
  const _GoldenApp({required this.locale, required this.state});

  final Locale locale;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: locale,
      supportedLocales: HomeLocalizations.supportedLocales,
      localizationsDelegates: const [
        HomeLocalizations.delegate,
        MovieUiLocalizations.delegate,
        CoreUiLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: RemoteImageScope(
        builder: (url) => ColoredBox(color: url == null ? Colors.black : Colors.blueGrey.shade700),
        child: HomeContent(
          state: state,
          favoriteButton: (_, _, size) => Icon(Icons.favorite, size: size),
          onRetry: () {},
          onRefresh: () async {},
          onMovieTap: (_, _) {},
          onSeeAll: (_) {},
          onSearch: () {},
        ),
      ),
    );
  }
}
