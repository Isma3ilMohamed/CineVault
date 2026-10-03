import 'package:bloc_test/bloc_test.dart';
import 'package:cine_vault/core/widgets/movie_ui/movie_ui.dart';
import 'package:cine_vault/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:cine_vault/features/movie_list/view/movie_list_view.dart';
import 'package:core_result/core_result.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
          find.byType(MovieListView),
          matchesGoldenFile('goldens/${name}_${locale.languageCode}.png'),
        );
      });
    }
  }
}

class _MockMovieListBloc extends MockBloc<MovieListEvent, MovieListState>
    implements MovieListBloc {}

class _GoldenApp extends StatelessWidget {
  const _GoldenApp({required this.locale, required this.state});

  final Locale locale;
  final MovieListState state;

  @override
  Widget build(BuildContext context) {
    final bloc = _MockMovieListBloc();
    when(() => bloc.state).thenReturn(state);
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
        child: BlocProvider<MovieListBloc>.value(
          value: bloc,
          child: MovieListView(
            category: MovieCategory.topRated,
            favoriteButton: (_, _, size) => Icon(Icons.favorite, size: size),
            onBack: () {},
            onMovieTap: (_, _) {},
          ),
        ),
      ),
    );
  }
}
