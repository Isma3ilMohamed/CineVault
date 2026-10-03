import 'package:cine_vault/features/favorites/favorites.dart';
import 'package:cine_vault/features/home/home.dart';
import 'package:cine_vault/features/movie_details/movie_details.dart';
import 'package:cine_vault/features/movie_list/movie_list.dart';
import 'package:cine_vault/features/search/search.dart';
import 'package:cine_vault/features/settings/settings.dart';
import 'package:cine_vault/routing/app_routes.dart';
import 'package:cine_vault/routing/app_shell.dart';
import 'package:cine_vault/routing/route_error_screen.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _favoritesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'favorites');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

/// The app's router: three tabs in a shell, and the screens above it. Each
/// route only parses its parameters and places a page; pages navigate
/// themselves with [AppRoutes].
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
          routes: [GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage())],
        ),
        StatefulShellBranch(
          navigatorKey: _favoritesNavigatorKey,
          routes: [GoRoute(path: AppRoutes.favorites, builder: (_, _) => const FavoritesPage())],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: [GoRoute(path: AppRoutes.settings, builder: (_, _) => const SettingsPage())],
        ),
      ],
    ),
    // Above the shell: the bottom navigation is hidden on these screens.
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.search,
      builder: (_, _) => const SearchPage(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.movieList,
      builder: (_, state) {
        final slug = state.pathParameters[RouteParams.category];
        final category = MovieCategory.values.asNameMap()[slug];
        if (category == null) return const RouteErrorScreen();
        return MovieListPage(category: category);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.movieDetails,
      builder: (_, state) {
        final id = int.tryParse(state.pathParameters[RouteParams.id] ?? '');
        if (id == null) return const RouteErrorScreen();
        return MovieDetailsPage(
          movieId: id,
          heroTag: state.uri.queryParameters[RouteParams.heroTag],
        );
      },
    ),
  ],
);
