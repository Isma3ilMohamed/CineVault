part of '../app_router.dart';

/// "See all" for one category, above the shell. An unknown category in the
/// URL falls through to the router's error screen.
@TypedGoRoute<MovieListRouteData>(path: '/list/:category')
class MovieListRouteData extends GoRouteData with $MovieListRouteData {
  const MovieListRouteData({required this.category});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavigatorKey;

  final MovieCategory category;

  @override
  Widget build(BuildContext context, GoRouterState state) => MovieListRoute(
    category: category,
    favoriteButton: favoriteButtonSlot,
    onBack: context.pop,
    onOpenMovie: (id, heroTag) =>
        unawaited(MovieDetailsRouteData(id: id, heroTag: heroTag).push<void>(context)),
  );
}
