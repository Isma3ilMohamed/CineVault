// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $movieDetailsRouteData,
  $movieListRouteData,
  $searchRouteData,
  $shellRouteData,
];

RouteBase get $movieDetailsRouteData => GoRouteData.$route(
  path: '/movie/:id',
  hasOverriddenOnExit: false,
  parentNavigatorKey: MovieDetailsRouteData.$parentNavigatorKey,
  factory: $MovieDetailsRouteData._fromState,
);

mixin $MovieDetailsRouteData on GoRouteData {
  static MovieDetailsRouteData _fromState(GoRouterState state) => MovieDetailsRouteData(
    id: int.parse(state.pathParameters['id']!),
    heroTag: state.uri.queryParameters['hero-tag'],
  );

  MovieDetailsRouteData get _self => this as MovieDetailsRouteData;

  @override
  String get location => GoRouteData.$location(
    '/movie/${Uri.encodeComponent(_self.id.toString())}',
    queryParams: {if (_self.heroTag != null) 'hero-tag': _self.heroTag},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $movieListRouteData => GoRouteData.$route(
  path: '/list/:category',
  hasOverriddenOnExit: false,
  parentNavigatorKey: MovieListRouteData.$parentNavigatorKey,
  factory: $MovieListRouteData._fromState,
);

mixin $MovieListRouteData on GoRouteData {
  static MovieListRouteData _fromState(GoRouterState state) => MovieListRouteData(
    category: _$MovieCategoryEnumMap._$fromName(state.pathParameters['category']!)!,
  );

  MovieListRouteData get _self => this as MovieListRouteData;

  @override
  String get location => GoRouteData.$location(
    '/list/${Uri.encodeComponent(_$MovieCategoryEnumMap[_self.category]!)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

const _$MovieCategoryEnumMap = {
  MovieCategory.trending: 'trending',
  MovieCategory.popular: 'popular',
  MovieCategory.topRated: 'top-rated',
  MovieCategory.nowPlaying: 'now-playing',
  MovieCategory.upcoming: 'upcoming',
};

extension<T extends Enum> on Map<T, String> {
  T? _$fromName(String? value) =>
      entries.where((element) => element.value == value).firstOrNull?.key;
}

RouteBase get $searchRouteData => GoRouteData.$route(
  path: '/search',
  hasOverriddenOnExit: false,
  parentNavigatorKey: SearchRouteData.$parentNavigatorKey,
  factory: $SearchRouteData._fromState,
);

mixin $SearchRouteData on GoRouteData {
  static SearchRouteData _fromState(GoRouterState state) => const SearchRouteData();

  @override
  String get location => GoRouteData.$location('/search');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $shellRouteData => StatefulShellRouteData.$route(
  factory: $ShellRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      navigatorKey: HomeBranchData.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/home',
          hasOverriddenOnExit: false,
          factory: $HomeRouteData._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: FavoritesBranchData.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/favorites',
          hasOverriddenOnExit: false,
          factory: $FavoritesRouteData._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      navigatorKey: MoreBranchData.$navigatorKey,
      routes: [
        GoRouteData.$route(
          path: '/more',
          hasOverriddenOnExit: false,
          factory: $SettingsRouteData._fromState,
        ),
      ],
    ),
  ],
);

extension $ShellRouteDataExtension on ShellRouteData {
  static ShellRouteData _fromState(GoRouterState state) => const ShellRouteData();
}

mixin $HomeRouteData on GoRouteData {
  static HomeRouteData _fromState(GoRouterState state) => const HomeRouteData();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FavoritesRouteData on GoRouteData {
  static FavoritesRouteData _fromState(GoRouterState state) => const FavoritesRouteData();

  @override
  String get location => GoRouteData.$location('/favorites');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRouteData on GoRouteData {
  static SettingsRouteData _fromState(GoRouterState state) => const SettingsRouteData();

  @override
  String get location => GoRouteData.$location('/more');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
