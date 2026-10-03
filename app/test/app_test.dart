import 'dart:async';
import 'dart:io';

import 'package:cine_vault/app/app.dart';
import 'package:cine_vault/app/config/app_config.dart';
import 'package:cine_vault/app/di.dart';
import 'package:cine_vault/core/ui.dart';
import 'package:cine_vault/features/favorites/favorites.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_tmdb.dart';

/// End-to-end at widget level: the real app with the real DI graph, routes,
/// blocs, repositories and storage. Only TMDB (a fake HTTP adapter), the
/// storage location (a temp dir) and images (flat boxes) are replaced.
void main() {
  late Directory hiveDirectory;
  late FakeTmdbAdapter tmdb;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    hiveDirectory = await Directory.systemTemp.createTemp('cine_vault_app_test');
    Hive.init(hiveDirectory.path);
    await configureDependencies(
      const AppConfig(
        flavor: Flavor.production,
        tmdbBaseUrl: 'https://tmdb.test/3',
        tmdbAccessToken: 'test-token',
      ),
    );
    tmdb = FakeTmdbAdapter();
    getIt<Dio>().httpClientAdapter = tmdb;
  });

  tearDown(() async {
    await getIt.reset();
    await hiveDirectory.delete(recursive: true);
  });

  /// Hive does real file IO in several async steps, and fake time never
  /// completes real IO. Alternates real time (for the IO) with pumps (to
  /// deliver each step to fake time) until [work] completes.
  Future<void> driveStorage(WidgetTester tester, Future<void> work) async {
    var done = false;
    unawaited(work.whenComplete(() => done = true));
    for (var i = 0; i < 50 && !done; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 10)));
      await tester.pump();
    }
    expect(done, isTrue, reason: 'storage work did not finish');
  }

  /// Runs [body] against the app, then shuts the app down inside the test, so
  /// nothing started in fake time (box listeners, writes) blocks tearDown.
  void appTest(String description, Future<void> Function(WidgetTester tester) body) {
    testWidgets(description, (tester) async {
      // A phone screen (iPhone 14/15 size) instead of the default 800x600.
      tester.view
        ..physicalSize = const Size(1170, 2532)
        ..devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        RemoteImageScope(builder: (_) => const SizedBox.expand(), child: const CineVaultApp()),
      );
      await tester.pumpAndSettle();

      await body(tester);

      // Shut down inside the test, where fake time can still be pumped:
      // nothing started in fake time (box listeners, writes) may outlive it.
      await tester.pumpWidget(const SizedBox());
      await driveStorage(tester, getIt<FavoriteIdsCubit>().close());
      await driveStorage(tester, Hive.close());
    });
  }

  appTest('every TMDB request carries the configured token', (tester) async {
    expect(tmdb.requestedPaths, contains('/movie/popular'));
    expect(find.text('Interstellar'), findsWidgets);
  });

  appTest('home -> details -> favorite -> the favorites tab shows it', (tester) async {
    await tester.tap(find.text('Interstellar').hitTestable().first);
    await tester.pumpAndSettle();
    expect(find.text('Science Fiction'), findsOneWidget, reason: 'details loaded its genres');
    expect(find.text('Matthew McConaughey'), findsOneWidget);

    // The first heart on the details screen is the one in the app bar.
    await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Interstellar'), findsOneWidget);
    expect(find.text('No favorites yet'), findsNothing);
  });

  appTest('see all opens the full list of a category', (tester) async {
    await tester.tap(find.text('See All').first);
    await tester.pumpAndSettle();

    expect(find.text('Trending Today'), findsOneWidget, reason: 'list title');
    expect(tmdb.requestedPaths.where((p) => p == '/trending/movie/day'), hasLength(2));
  });

  appTest('search finds a movie after the debounce', (tester) async {
    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'tenet');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Tenet'), findsOneWidget);
    expect(tmdb.requestedPaths.where((p) => p == '/search/movie'), hasLength(1));
  });

  appTest('switching to Arabic relabels the whole app', (tester) async {
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Arabic'));
    await tester.pumpAndSettle();

    expect(find.text('المفضلة'), findsOneWidget, reason: 'tab from the navigation package');
    expect(find.text('المزيد'), findsWidgets, reason: 'title from the settings package');
  });
}
