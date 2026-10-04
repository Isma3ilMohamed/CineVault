import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/core/ui.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
  theme: AppTheme.darkTheme,
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
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

void main() {
  group('TmdbImages', () {
    test('builds CDN URLs per size and keeps null paths null', () {
      expect(TmdbImages.poster('/p.jpg'), 'https://image.tmdb.org/t/p/w500/p.jpg');
      expect(TmdbImages.backdrop('/b.jpg'), 'https://image.tmdb.org/t/p/w1280/b.jpg');
      expect(TmdbImages.profile(null), isNull);
    });

    test('formats ratings and years', () {
      expect(MovieFormat.rating(7.25), '7.3');
      expect(MovieFormat.year(DateTime(2010)), '2010');
      expect(MovieFormat.year(null), isNull);
    });
  });

  group('RemoteImage.decodeWidth', () {
    test('a poster card on a 3x screen decodes at 420px, not at its full 500px+', () {
      expect(
        RemoteImage.decodeWidth(
          constraints: BoxConstraints.tight(const Size(140, 210)),
          devicePixelRatio: 3,
          sourceAspectRatio: TmdbImages.posterAspectRatio,
        ),
        420,
      );
    });

    test('a cover backdrop in a wide box is decoded wide enough not to upscale', () {
      // 402x280 box, 16:9 image: cover scales by height -> 280 * 16/9 = 498 pt.
      expect(
        RemoteImage.decodeWidth(
          constraints: BoxConstraints.tight(const Size(402, 280)),
          devicePixelRatio: 3,
          sourceAspectRatio: TmdbImages.backdropAspectRatio,
        ),
        1494,
      );
    });

    test('unknown aspect ratio uses the box width; unbounded width decodes at full size', () {
      expect(
        RemoteImage.decodeWidth(
          constraints: BoxConstraints.tight(const Size(100, 100)),
          devicePixelRatio: 2,
        ),
        200,
      );
      expect(
        RemoteImage.decodeWidth(
          constraints: const BoxConstraints(maxHeight: 100),
          devicePixelRatio: 2,
        ),
        isNull,
      );
    });
  });

  testWidgets('FailureText picks the localized message by failure type', (tester) async {
    late String network;
    late String server;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) {
            network = const NetworkFailure(message: 'raw').localizedMessage(context);
            server = const ServerFailure(message: 'raw').localizedMessage(context);
            return const SizedBox();
          },
        ),
        locale: const Locale('ar'),
      ),
    );
    expect(network, 'مفيش اتصال بالإنترنت');
    expect(server, 'خطأ في الخادم');
  });

  testWidgets('PosterCard shows its values and the leading slot', (tester) async {
    await tester.pumpWidget(
      _app(
        const PosterCard(
          title: 'Inception',
          posterUrl: 'https://x/p.jpg',
          rating: '8.4',
          year: '2010',
          leading: Icon(Icons.favorite, key: Key('slot')),
        ),
      ),
    );
    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('8.4'), findsOneWidget);
    expect(find.text('2010'), findsOneWidget);
    expect(find.byKey(const Key('slot')), findsOneWidget);
  });

  testWidgets('PosterCard shows the localized fallback for an unknown year', (tester) async {
    await tester.pumpWidget(
      _app(
        const PosterCard(title: 'Untitled', posterUrl: null, rating: '0.0', year: null),
        locale: const Locale('ar'),
      ),
    );
    expect(find.text('غير معروف'), findsOneWidget);
  });

  testWidgets('showAppDialog hands the content a working close callback', (tester) async {
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showAppDialog(
              context: context,
              builder: (_, close) => TextButton(onPressed: close, child: const Text('close')),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('close'), findsOneWidget);

    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();
    expect(find.text('close'), findsNothing);
  });
}
