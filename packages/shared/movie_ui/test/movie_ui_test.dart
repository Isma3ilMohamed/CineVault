import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_ui/movie_ui.dart';

Movie _movie(int id) => Movie(
  id: id,
  title: 'Movie $id',
  overview: '',
  voteAverage: 7,
  voteCount: 10,
  genreIds: const [],
  originalLanguage: 'en',
  popularity: 1,
  adult: false,
);

Widget _app(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
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
  home: Scaffold(
    body: RemoteImageScope(
      builder: (_) => const ColoredBox(color: Colors.grey),
      child: child,
    ),
  ),
);

Widget _heart(BuildContext context, Movie movie, double size) =>
    Icon(Icons.favorite, key: ValueKey('heart_${movie.id}'), size: size);

void main() {
  testWidgets('category labels are localized', (tester) async {
    late String label;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) {
            label = MovieCategory.topRated.label(context);
            return const SizedBox();
          },
        ),
        locale: const Locale('ar'),
      ),
    );
    expect(label, 'الأعلى تقييماً');
  });

  testWidgets('MovieCard fills the favorite slot and reports taps', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _app(MovieCard(movie: _movie(7), favoriteButton: _heart, onTap: () => tapped = true)),
    );
    expect(find.byKey(const ValueKey('heart_7')), findsOneWidget);
    await tester.tap(find.text('Movie 7'));
    expect(tapped, isTrue);
  });

  testWidgets('MovieGrid passes the prefixed hero tag on tap', (tester) async {
    String? tag;
    await tester.pumpWidget(
      _app(
        MovieGrid(
          movies: [_movie(1), _movie(2)],
          heroTagPrefix: 'search',
          favoriteButton: _heart,
          onMovieTap: (_, heroTag) => tag = heroTag,
        ),
      ),
    );
    await tester.tap(find.text('Movie 2'));
    expect(tag, 'search_2');
  });

  testWidgets('MovieGrid asks for more near the end, but not while loading', (tester) async {
    var calls = 0;
    Widget grid({required bool isLoadingMore}) => _app(
      MovieGrid(
        movies: [for (var i = 0; i < 20; i++) _movie(i)],
        heroTagPrefix: 'list',
        favoriteButton: _heart,
        onMovieTap: (_, _) {},
        isLoadingMore: isLoadingMore,
        onLoadMore: () => calls++,
      ),
    );

    await tester.pumpWidget(grid(isLoadingMore: true));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -20000));
    await tester.pump();
    expect(calls, 0);

    // Still at the end: any scroll there now asks for more.
    await tester.pumpWidget(grid(isLoadingMore: false));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 100));
    await tester.pump();
    expect(calls, greaterThan(0));
  });
}
