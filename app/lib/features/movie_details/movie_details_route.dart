import 'package:cine_vault/core/widgets/movie_ui/movie_ui.dart';
import 'package:cine_vault/features/movie_details/movie_details_bloc.dart';
import 'package:cine_vault/features/movie_details/movie_details_contract.dart';
import 'package:cine_vault/features/movie_details/movie_details_navigation.dart';
import 'package:cine_vault/features/movie_details/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Entry and exit point of the feature.
///
/// Entry: creates the bloc for [movieId] and starts it once. Exit: turns every
/// [MovieDetailsNavigation] into one of the callbacks below, so the feature
/// never knows about the router.
class MovieDetailsRoute extends StatelessWidget {
  const MovieDetailsRoute({
    required this.movieId,
    required this.onBack,
    required this.onOpenMovie,
    required this.favoriteButton,
    super.key,
    this.heroTag,
  });

  final int movieId;
  final VoidCallback onBack;
  final void Function(int movieId, String heroTag) onOpenMovie;
  final FavoriteButtonBuilder favoriteButton;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<MovieDetailsBloc>(param1: movieId)..add(const MovieDetailsEvent.started()),
      child: MovieDetailsScreen(
        heroTag: heroTag,
        favoriteButton: favoriteButton,
        onNavigation: (navigation) => switch (navigation) {
          NavigateBack() => onBack(),
          OpenSimilarMovie(:final movieId, :final heroTag) => onOpenMovie(movieId, heroTag),
        },
      ),
    );
  }
}
