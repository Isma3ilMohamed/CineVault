import 'package:core_result/core_result.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_details/movie_details.dart';
import 'package:movie_details/src/movie_details_content.dart';
import 'package:movie_details/src/movie_details_contract.dart';

import 'fixtures.dart';

/// Golden tests replace the "preview" of the CMP Content: every state, in
/// English and Arabic (RTL). Regenerate with `flutter test --update-goldens`.
void main() {
  final loaded = MovieDetailsState.loaded(
    movie: movie(1),
    similarMovies: [movie(2), movie(3), movie(4)],
    cast: castMembers,
    genres: const ['Action', 'Science Fiction'],
    trailer: trailer,
  );

  final states = <String, MovieDetailsState>{
    'loading': const MovieDetailsState.loading(),
    'error': const MovieDetailsState.error(NetworkFailure()),
    'loaded': loaded,
  };

  for (final locale in const [Locale('en'), Locale('ar')]) {
    for (final MapEntry(key: name, value: state) in states.entries) {
      testWidgets('$name (${locale.languageCode})', (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(_GoldenApp(locale: locale, state: state));
        // The loading spinner never settles; one frame is enough for it.
        await tester.pump();

        await expectLater(
          find.byType(MovieDetailsContent),
          matchesGoldenFile('goldens/${name}_${locale.languageCode}.png'),
        );
      });
    }
  }
}

class _GoldenApp extends StatelessWidget {
  const _GoldenApp({required this.locale, required this.state});

  final Locale locale;
  final MovieDetailsState state;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: locale,
      supportedLocales: MovieDetailsLocalizations.supportedLocales,
      localizationsDelegates: const [
        MovieDetailsLocalizations.delegate,
        CoreUiLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: RemoteImageScope(
        // Flat color per URL kind instead of network images.
        builder: (url) => ColoredBox(color: url == null ? Colors.black : Colors.blueGrey.shade700),
        child: MovieDetailsContent(
          state: state,
          favoriteButton: (_, _, size) => Icon(Icons.favorite_border, size: size),
          onBack: () {},
          onRetry: () {},
          onMovieTap: (_, _) {},
          onPlayTrailer: (_, _) {},
        ),
      ),
    );
  }
}
