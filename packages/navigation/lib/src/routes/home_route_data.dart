part of '../app_router.dart';

class HomeRouteData extends GoRouteData with $HomeRouteData {
  const HomeRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => HomeRoute(
    favoriteButton: favoriteButtonSlot,
    onOpenMovie: (id, heroTag) =>
        unawaited(MovieDetailsRouteData(id: id, heroTag: heroTag).push<void>(context)),
    onOpenCategory: (category) =>
        unawaited(MovieListRouteData(category: category).push<void>(context)),
    onOpenSearch: () => unawaited(const SearchRouteData().push<void>(context)),
  );
}
