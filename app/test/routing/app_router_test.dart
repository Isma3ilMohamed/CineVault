import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:cine_vault/routing/app_router.dart';
import 'package:cine_vault/routing/app_routes.dart';
import 'package:cine_vault/routing/route_error_screen.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(String location) => MaterialApp.router(
  routerConfig: createAppRouter(initialLocation: location),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    CoreUiLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
);

void main() {
  test('location builders produce the paths the router matches', () {
    expect(AppRoutes.movieDetailsOf(27205), '/movie/27205');
    expect(
      AppRoutes.movieDetailsOf(27205, heroTag: 'trending_27205'),
      '/movie/27205?heroTag=trending_27205',
    );
    expect(AppRoutes.movieListOf(MovieCategory.topRated), '/movies/topRated');
    expect(AppRoutes.movieList, '/movies/:category');
    expect(AppRoutes.movieDetails, '/movie/:id');
  });

  for (final location in ['/nowhere', '/movie/abc', '/movies/unknown']) {
    testWidgets('$location shows the route error screen', (tester) async {
      await tester.pumpWidget(_app(location));
      await tester.pumpAndSettle();
      expect(find.byType(RouteErrorScreen), findsOneWidget);
    });
  }
}
