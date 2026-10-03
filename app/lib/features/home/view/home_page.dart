import 'dart:async';

import 'package:cine_vault/app/di.dart';
import 'package:cine_vault/features/favorites/view/favorite_button.dart';
import 'package:cine_vault/features/home/bloc/home_bloc.dart';
import 'package:cine_vault/features/home/view/home_view.dart';
import 'package:cine_vault/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Home screen entry: provides the bloc, starts it once, and wires the view's
/// taps to navigation.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(const HomeEvent.started()),
      child: HomeView(
        favoriteButton: (_, movie, size) => FavoriteButton(movie: movie, size: size),
        onMovieTap: (movie, heroTag) =>
            unawaited(context.push(AppRoutes.movieDetailsOf(movie.id, heroTag: heroTag))),
        onSeeAll: (category) => unawaited(context.push(AppRoutes.movieListOf(category))),
        onSearch: () => unawaited(context.push(AppRoutes.search)),
      ),
    );
  }
}
