import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigation/navigation.dart';
import 'package:navigation/src/app_router.dart';
import 'package:navigation/src/route_error_screen.dart';

Widget _app(String location) => MaterialApp.router(
  routerConfig: createAppRouter(initialLocation: location),
  supportedLocales: NavigationLocalizations.supportedLocales,
  localizationsDelegates: const [
    NavigationLocalizations.delegate,
    CoreUiLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
);

void main() {
  test('typed routes build plain URLs', () {
    expect(const MovieDetailsRouteData(id: 27205).location, '/movie/27205');
    expect(
      const MovieDetailsRouteData(id: 27205, heroTag: 'trending_27205').location,
      '/movie/27205?hero-tag=trending_27205',
    );
    expect(const MovieListRouteData(category: MovieCategory.topRated).location, '/list/top-rated');
    expect(const SearchRouteData().location, '/search');
    expect(const HomeRouteData().location, '/home');
  });

  for (final location in ['/nowhere', '/movie/abc', '/list/unknown']) {
    testWidgets('$location shows the route error screen', (tester) async {
      await tester.pumpWidget(_app(location));
      await tester.pumpAndSettle();
      expect(find.byType(RouteErrorScreen), findsOneWidget);
    });
  }
}
