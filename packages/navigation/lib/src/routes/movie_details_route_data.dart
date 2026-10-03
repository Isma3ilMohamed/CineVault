part of '../app_router.dart';

/// Movie details, above the shell.
///
/// [heroTag] is an optional query parameter (`?hero-tag=`) instead of
/// `state.extra`, so the location is a plain URL that also works as a deep
/// link (no tag, no Hero animation).
@TypedGoRoute<MovieDetailsRouteData>(path: '/movie/:id')
class MovieDetailsRouteData extends GoRouteData with $MovieDetailsRouteData {
  const MovieDetailsRouteData({required this.id, this.heroTag});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = _rootNavigatorKey;

  final int id;
  final String? heroTag;

  @override
  Widget build(BuildContext context, GoRouterState state) => MovieDetailsRoute(
    movieId: id,
    heroTag: heroTag,
    favoriteButton: favoriteButtonSlot,
    onBack: context.pop,
    onOpenMovie: (id, heroTag) =>
        unawaited(MovieDetailsRouteData(id: id, heroTag: heroTag).push<void>(context)),
  );
}
