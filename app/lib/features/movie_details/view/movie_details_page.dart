import 'dart:async';

import 'package:cine_vault/core/di/injection.dart';
import 'package:cine_vault/features/favorites/view/favorite_button.dart';
import 'package:cine_vault/features/movie_details/bloc/movie_details_bloc.dart';
import 'package:cine_vault/features/movie_details/view/movie_details_view.dart';
import 'package:cine_vault/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Details entry for [movieId]: provides the bloc, starts it once, and wires
/// the view's taps to navigation. [heroTag] matches the tapped poster.
class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage({required this.movieId, super.key, this.heroTag});

  final int movieId;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<MovieDetailsBloc>(param1: movieId)..add(const MovieDetailsEvent.started()),
      child: MovieDetailsView(
        heroTag: heroTag,
        favoriteButton: (_, movie, size) => FavoriteButton(movie: movie, size: size),
        onBack: context.pop,
        onMovieTap: (movie, heroTag) =>
            unawaited(context.push(AppRoutes.movieDetailsOf(movie.id, heroTag: heroTag))),
      ),
    );
  }
}
