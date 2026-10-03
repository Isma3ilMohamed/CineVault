import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_details/src/movie_details_bloc.dart';
import 'package:movie_details/src/movie_details_content.dart';
import 'package:movie_details/src/movie_details_contract.dart';
import 'package:movie_details/src/movie_details_navigation.dart';
import 'package:movie_details/src/widgets/trailer_player_modal.dart';

/// Binds the bloc to [MovieDetailsContent]: state down, taps up as either bloc
/// events or [MovieDetailsNavigation]. Owns UI-only overlays (the trailer).
class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({
    required this.favoriteButton,
    required this.onNavigation,
    super.key,
    this.heroTag,
  });

  final FavoriteButtonBuilder favoriteButton;
  final ValueChanged<MovieDetailsNavigation> onNavigation;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MovieDetailsBloc>();
    return BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, state) => MovieDetailsContent(
        state: state,
        heroTag: heroTag,
        favoriteButton: favoriteButton,
        onBack: () => onNavigation(const NavigateBack()),
        onRetry: () => bloc.add(const MovieDetailsEvent.retried()),
        onMovieTap: (movie, tag) => onNavigation(OpenSimilarMovie(movieId: movie.id, heroTag: tag)),
        onPlayTrailer: (trailer, title) => showAppDialog(
          context: context,
          builder: (_, close) =>
              TrailerPlayerModal(videoKey: trailer.key, title: title, onClose: close),
        ),
      ),
    );
  }
}
