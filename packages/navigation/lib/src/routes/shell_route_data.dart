part of '../app_router.dart';

final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _favoritesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'favorites');
final _moreNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'more');

/// The bottom-navigation shell. Each tab keeps its own navigation stack.
@TypedStatefulShellRoute<ShellRouteData>(
  branches: [
    TypedStatefulShellBranch<HomeBranchData>(routes: [TypedGoRoute<HomeRouteData>(path: '/home')]),
    TypedStatefulShellBranch<FavoritesBranchData>(
      routes: [TypedGoRoute<FavoritesRouteData>(path: '/favorites')],
    ),
    TypedStatefulShellBranch<MoreBranchData>(
      routes: [TypedGoRoute<SettingsRouteData>(path: '/more')],
    ),
  ],
)
class ShellRouteData extends StatefulShellRouteData {
  const ShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => AppShell(navigationShell: navigationShell);
}

class HomeBranchData extends StatefulShellBranchData {
  const HomeBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = _homeNavigatorKey;
}

class FavoritesBranchData extends StatefulShellBranchData {
  const FavoritesBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = _favoritesNavigatorKey;
}

class MoreBranchData extends StatefulShellBranchData {
  const MoreBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = _moreNavigatorKey;
}
