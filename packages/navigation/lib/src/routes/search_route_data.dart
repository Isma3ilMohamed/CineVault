part of '../app_router.dart';

/// Above the shell: the bottom navigation is hidden while searching.
@TypedGoRoute<SearchRouteData>(path: '/search')
class SearchRouteData extends GoRouteData with $SearchRouteData {
  const SearchRouteData();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => SearchRoute(
    favoriteButton: favoriteButtonSlot,
    onBack: context.pop,
    onOpenMovie: (id, heroTag) =>
        unawaited(MovieDetailsRouteData(id: id, heroTag: heroTag).push<void>(context)),
  );
}
