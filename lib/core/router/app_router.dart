import 'dart:async';

import 'package:cine_vault/core/widgets/app_shell.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:domain/domain.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:home/home.dart';
import 'package:movie_details/movie_details.dart';
import 'package:movie_list/movie_list.dart';
import 'package:search/search.dart';
import 'package:settings/settings.dart';

/// `router(themeBoundaryKey)`: the key must sit on the RepaintBoundary wrapping
/// the app; the settings screen snapshots it for the theme toggle.
///
/// Every screen is a feature Route; this file only maps their exit callbacks
/// to locations. Typed routes replace the strings in Phase 7.
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
                  builder: (context, state) => HomeRoute(
                    favoriteButton: _favoriteButton,
                    onOpenMovie: (id, heroTag) => _openMovie(context, id, heroTag),
                    onOpenCategory: (category) => unawaited(context.push('/list/${category.slug}')),
                    onOpenSearch: () => unawaited(context.push('/search')),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _favoritesNavigatorKey,
              routes: [
                GoRoute(
                  path: '/favorites',
                  name: 'favorites',
                  builder: (context, state) => FavoritesRoute(
                    onOpenMovie: (id, heroTag) => _openMovie(context, id, heroTag),
                    onOpenSearch: () => unawaited(context.push('/search')),
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
                  builder: (context, state) => SettingsRoute(themeBoundaryKey: themeBoundaryKey),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/search',
          name: 'search',
          builder: (context, state) => SearchRoute(
            favoriteButton: _favoriteButton,
            onBack: context.pop,
            onOpenMovie: (id, heroTag) => _openMovie(context, id, heroTag),
          ),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/list/:category',
          name: 'movieList',
          builder: (context, state) {
            final category = MovieCategory.fromSlug(state.pathParameters['category']);
            if (category == null) {
              return _InvalidRoute((l10n) => l10n.invalidCategory);
            }
            return MovieListRoute(
              category: category,
              favoriteButton: _favoriteButton,
              onBack: context.pop,
              onOpenMovie: (id, heroTag) => _openMovie(context, id, heroTag),
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/movie/:id',
          name: 'movieDetails',
          builder: (context, state) {
            final movieId = int.tryParse(state.pathParameters['id'] ?? '');
            if (movieId == null) {
              return _InvalidRoute((l10n) => l10n.detailsInvalidMovieId);
            }
            final extra = state.extra;
            final heroTag = (extra is Map<String, Object?>) ? extra['heroTag'] as String? : null;
            return MovieDetailsRoute(
              movieId: movieId,
              heroTag: heroTag,
              favoriteButton: _favoriteButton,
              onBack: context.pop,
              onOpenMovie: (id, heroTag) => _openMovie(context, id, heroTag),
            );
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text(AppLocalizations.of(context).errorPrefix('${state.error}'))),
      ),
    );
  }

  static void _openMovie(BuildContext context, int movieId, String heroTag) {
    unawaited(context.push('/movie/$movieId', extra: {'heroTag': heroTag}));
  }

  /// Fills every feature's favorite-button slot with the favorites feature's button.
  static Widget _favoriteButton(BuildContext context, Movie movie, double size) =>
      FavoriteButton(movie: movie, size: size);
}

class _InvalidRoute extends StatelessWidget {
  const _InvalidRoute(this.message);

  final String Function(AppLocalizations l10n) message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(message(AppLocalizations.of(context)))));
  }
}
