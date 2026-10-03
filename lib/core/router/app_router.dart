import 'package:cine_vault/core/di/injection_container.dart';
import 'package:cine_vault/core/widgets/app_shell.dart';
import 'package:cine_vault/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:cine_vault/features/favorites/presentation/pages/favorites_page.dart';
import 'package:cine_vault/features/favorites/presentation/widgets/favorite_heart_button.dart';
import 'package:cine_vault/features/movies/presentation/bloc/movie_list_bloc.dart';
import 'package:cine_vault/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:cine_vault/features/movies/presentation/pages/home_page.dart';
import 'package:cine_vault/features/movies/presentation/pages/movie_list_page.dart';
import 'package:cine_vault/features/search/presentation/bloc/search_bloc.dart';
import 'package:cine_vault/features/search/presentation/pages/search_page.dart';
import 'package:cine_vault/features/settings/presentation/pages/more_page.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_details/movie_details.dart';

/// `router(themeBoundaryKey)`: the key must sit on the RepaintBoundary wrapping
/// the app; MorePage passes it to ThemeRevealController for the theme toggle.
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>();
  static final _favoritesNavigatorKey = GlobalKey<NavigatorState>();
  static final _moreNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router(GlobalKey themeBoundaryKey) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              navigatorKey: _homeNavigatorKey,
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) =>
                      BlocProvider(create: (_) => sl<MoviesBloc>(), child: const HomePage()),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _favoritesNavigatorKey,
              routes: [
                GoRoute(
                  path: '/favorites',
                  name: 'favorites',
                  builder: (context, state) => BlocProvider(
                    create: (_) => sl<FavoritesBloc>()..add(const FavoritesSubscribed()),
                    child: const FavoritesPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _moreNavigatorKey,
              routes: [
                GoRoute(
                  path: '/more',
                  name: 'more',
                  builder: (context, state) => MorePage(themeBoundaryKey: themeBoundaryKey),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/search',
          name: 'search',
          builder: (context, state) => BlocProvider(
            create: (_) => sl<SearchBloc>()..add(const SearchStarted()),
            child: const SearchPage(),
          ),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/list/:category',
          name: 'movieList',
          builder: (context, state) {
            final category = MovieCategory.fromSlug(state.pathParameters['category']);
            if (category == null) {
              return const Scaffold(body: Center(child: Text('Invalid category')));
            }
            return BlocProvider(
              create: (_) => sl<MovieListBloc>(param1: category)..add(const MovieListStarted()),
              child: MovieListPage(category: category),
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/movie/:id',
          name: 'movieDetails',
          builder: (context, state) {
            final rawId = state.pathParameters['id'];
            final movieId = int.tryParse(rawId ?? '');
            if (movieId == null) {
              return const _InvalidMovieRoute();
            }
            final extra = state.extra;
            final heroTag = (extra is Map<String, Object?>) ? extra['heroTag'] as String? : null;
            return MovieDetailsRoute(
              movieId: movieId,
              heroTag: heroTag,
              onBack: context.pop,
              onOpenMovie: (id, tag) => context.push('/movie/$id', extra: {'heroTag': tag}),
              favoriteButton: (_, movie, size) => FavoriteHeartButton(movie: movie, size: size),
            );
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text(AppLocalizations.of(context).errorPrefix('${state.error}'))),
      ),
    );
  }
}

class _InvalidMovieRoute extends StatelessWidget {
  const _InvalidMovieRoute();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(AppLocalizations.of(context).detailsInvalidMovieId)));
  }
}
