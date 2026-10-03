import 'dart:async';

import 'package:cine_vault/core/di/injection.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/favorites/view/favorite_button.dart';
import 'package:cine_vault/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:cine_vault/features/movie_list/view/movie_list_view.dart';
import 'package:cine_vault/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// "See all" entry for one [category]: provides the bloc, starts it once, and
/// wires the view's taps to navigation.
class MovieListPage extends StatelessWidget {
  const MovieListPage({required this.category, super.key});

  final MovieCategory category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MovieListBloc>(param1: category)..add(const MovieListEvent.started()),
      child: MovieListView(
        category: category,
        favoriteButton: (_, movie, size) => FavoriteButton(movie: movie, size: size),
        onBack: context.pop,
        onMovieTap: (movie, heroTag) =>
            unawaited(context.push(AppRoutes.movieDetailsOf(movie.id, heroTag: heroTag))),
      ),
    );
  }
}
