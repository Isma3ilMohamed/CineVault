import 'dart:async';

import 'package:cine_vault/core/di/injection.dart';
import 'package:cine_vault/features/favorites/bloc/favorites_bloc.dart';
import 'package:cine_vault/features/favorites/view/favorite_button.dart';
import 'package:cine_vault/features/favorites/view/favorites_view.dart';
import 'package:cine_vault/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Favorites screen entry: provides the bloc, starts it once, and wires the
/// view's taps to navigation.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FavoritesBloc>()..add(const FavoritesEvent.started()),
      child: FavoritesView(
        favoriteButton: (_, movie, size) => FavoriteButton(movie: movie, size: size),
        onMovieTap: (movie, heroTag) =>
            unawaited(context.push(AppRoutes.movieDetailsOf(movie.id, heroTag: heroTag))),
        onSearch: () => unawaited(context.push(AppRoutes.search)),
      ),
    );
  }
}
