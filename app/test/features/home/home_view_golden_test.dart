import 'package:bloc_test/bloc_test.dart';
import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/core/ui.dart';
import 'package:cine_vault/core/widgets/movie_ui/movie_ui.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/home/bloc/home_bloc.dart';
import 'package:cine_vault/features/home/home.dart';
import 'package:cine_vault/features/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
          find.byType(HomeView),
          matchesGoldenFile('goldens/${name}_${locale.languageCode}.png'),
        );
      });
    }
  }
}

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

class _GoldenApp extends StatelessWidget {
  const _GoldenApp({required this.locale, required this.state});

  final Locale locale;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final bloc = _MockHomeBloc();
    when(() => bloc.state).thenReturn(state);
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
        child: BlocProvider<HomeBloc>.value(
          value: bloc,
          child: HomeView(
            favoriteButton: (_, _, size) => Icon(Icons.favorite, size: size),
            onMovieTap: (_, _) {},
            onSeeAll: (_) {},
            onSearch: () {},
          ),
        ),
      ),
    );
  }
}
