import 'dart:async';

import 'package:cine_vault/routing/app_routes.dart';
import 'package:cine_vault/routing/app_shell.dart';
import 'package:cine_vault/routing/favorite_button_slot.dart';
import 'package:cine_vault/routing/route_error_screen.dart';
import 'package:domain/domain.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:home/home.dart';
import 'package:movie_details/movie_details.dart';
import 'package:movie_list/movie_list.dart';
import 'package:search/search.dart';
import 'package:settings/settings.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _favoritesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'favorites');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

/// The app's router: three tabs in a shell, and the screens above it.
///
/// Create it once (not in `build`): its navigator keys are global.
/// [initialLocation] defaults to home; tests start elsewhere.
GoRouter createAppRouter({String initialLocation = AppRoutes.home}) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: initialLocation,
  errorBuilder: (_, _) => const RouteErrorScreen(),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (_, _, navigationShell) => AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, _) => HomeRoute(
                favoriteButton: favoriteButtonSlot,
                onOpenMovie: (id, heroTag) => _openMovie(context, id, heroTag),
                onOpenCategory: (category) =>
                    unawaited(context.push(AppRoutes.movieListOf(category))),
                onOpenSearch: () => unawaited(context.push(AppRoutes.search)),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _favoritesNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.favorites,
              builder: (context, _) => FavoritesRoute(
                onOpenMovie: (id, heroTag) => _openMovie(context, id, heroTag),
                onOpenSearch: () => unawaited(context.push(AppRoutes.search)),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [GoRoute(path: AppRoutes.settings, builder: (_, _) => const SettingsRoute())],
        ),
      ],
    ),
    // Above the shell: the bottom navigation is hidden on these screens.
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.search,
      builder: (context, _) => SearchRoute(
        favoriteButton: favoriteButtonSlot,
        onBack: context.pop,
        onOpenMovie: (id, heroTag) => _openMovie(context, id, heroTag),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.movieList,
      builder: (context, state) {
        final slug = state.pathParameters[RouteParams.category];
        final category = MovieCategory.values.asNameMap()[slug];
        if (category == null) return const RouteErrorScreen();
        return MovieListRoute(
          category: category,
          favoriteButton: favoriteButtonSlot,
          onBack: context.pop,
          onOpenMovie: (id, heroTag) => _openMovie(context, id, heroTag),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.movieDetails,
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters[RouteParams.id] ?? '');
        if (id == null) return const RouteErrorScreen();
        return MovieDetailsRoute(
          movieId: id,
          heroTag: state.uri.queryParameters[RouteParams.heroTag],
          favoriteButton: favoriteButtonSlot,
          onBack: context.pop,
          onOpenMovie: (id, heroTag) => _openMovie(context, id, heroTag),
        );
      },
    ),
  ],
);

void _openMovie(BuildContext context, int id, String heroTag) {
  unawaited(context.push(AppRoutes.movieDetailsOf(id, heroTag: heroTag)));
}
