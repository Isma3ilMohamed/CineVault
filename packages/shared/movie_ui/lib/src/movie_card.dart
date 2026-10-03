import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:movie_ui/src/favorite_button_builder.dart';

/// [PosterCard] for a [Movie], with the favorite toggle in its leading slot.
class MovieCard extends StatelessWidget {
  const MovieCard({
    required this.movie,
    required this.favoriteButton,
    super.key,
    this.onTap,
    this.heroTag,
    this.width = 140,
    this.height = 210,
  });

  final Movie movie;
  final FavoriteButtonBuilder favoriteButton;
  final VoidCallback? onTap;

  /// Must be unique on the screen when the same movie can appear more than once;
  /// null disables the Hero.
  final String? heroTag;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return PosterCard(
      title: movie.title,
      posterUrl: TmdbImages.poster(movie.posterPath),
      rating: MovieFormat.rating(movie.voteAverage),
      year: MovieFormat.year(movie.releaseDate),
      onTap: onTap,
      heroTag: heroTag,
      width: width,
      height: height,
      leading: favoriteButton(context, movie, 18),
    );
  }
}
