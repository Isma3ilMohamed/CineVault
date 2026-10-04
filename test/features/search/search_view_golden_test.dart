import 'package:bloc_test/bloc_test.dart';
import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/core/ui.dart';
import 'package:cine_vault/features/search/bloc/search_bloc.dart';
import 'package:cine_vault/features/search/view/search_view.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
          find.byType(SearchView),
          matchesGoldenFile('goldens/${name}_${locale.languageCode}.png'),
        );
      });
    }
  }
}

class _MockSearchBloc extends MockBloc<SearchEvent, SearchState> implements SearchBloc {}

class _GoldenApp extends StatelessWidget {
  const _GoldenApp({required this.locale, required this.state});

  final Locale locale;
  final SearchState state;

  @override
  Widget build(BuildContext context) {
    final bloc = _MockSearchBloc();
    when(() => bloc.state).thenReturn(state);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: RemoteImageScope(
        builder: (url) => ColoredBox(color: url == null ? Colors.black : Colors.blueGrey.shade700),
        child: BlocProvider<SearchBloc>.value(
          value: bloc,
          child: SearchView(
            favoriteButton: (_, _, size) => Icon(Icons.favorite, size: size),
            onBack: () {},
            onMovieTap: (_, _) {},
          ),
        ),
      ),
    );
  }
}
