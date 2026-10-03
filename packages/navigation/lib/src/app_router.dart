import 'dart:async';

import 'package:domain/domain.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:home/home.dart';
import 'package:movie_details/movie_details.dart';
import 'package:movie_list/movie_list.dart';
import 'package:navigation/src/app_shell.dart';
import 'package:navigation/src/favorite_button_slot.dart';
import 'package:navigation/src/route_error_screen.dart';
import 'package:search/search.dart';
import 'package:settings/settings.dart';

part 'app_router.g.dart';
part 'routes/favorites_route_data.dart';
part 'routes/home_route_data.dart';
part 'routes/movie_details_route_data.dart';
part 'routes/movie_list_route_data.dart';
part 'routes/search_route_data.dart';
part 'routes/settings_route_data.dart';
part 'routes/shell_route_data.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// The app's router.
///
/// The route tree is declared by the `@TypedGoRoute` annotations in `routes/`,
/// one file per screen, and go_router_builder generates `$appRoutes` from
/// them. Each route data class only maps its feature's exit callbacks to
/// other routes; DI and blocs live in the features' Routes.
///
/// Create it once (not in `build`): its navigator keys are global.
/// [initialLocation] defaults to home; tests start elsewhere.
GoRouter createAppRouter({String? initialLocation}) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: initialLocation ?? const HomeRouteData().location,
  routes: $appRoutes,
  errorBuilder: (context, state) => const RouteErrorScreen(),
);
