part of '../app_router.dart';

class FavoritesRouteData extends GoRouteData with $FavoritesRouteData {
  const FavoritesRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => FavoritesRoute(
    onOpenMovie: (id, heroTag) =>
        unawaited(MovieDetailsRouteData(id: id, heroTag: heroTag).push<void>(context)),
    onOpenSearch: () => unawaited(const SearchRouteData().push<void>(context)),
  );
}
