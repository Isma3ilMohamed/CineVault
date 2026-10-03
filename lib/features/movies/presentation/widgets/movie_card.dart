import 'package:cine_vault/features/favorites/presentation/widgets/favorite_heart_button.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

/// [PosterCard] for a [Movie], with the favorite toggle in its slot.
class MovieCard extends StatelessWidget {
  const MovieCard({
    required this.movie,
    super.key,
    this.onTap,
    this.width = 140,
    this.height = 210,
    this.heroTag,
  });
  final Movie movie;
  final VoidCallback? onTap;
  final double width;
  final double height;

  /// Must be unique on the screen when the same movie can appear more than once;
  /// null disables the Hero.
  final String? heroTag;

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
      leading: FavoriteHeartButton(movie: movie, size: 18),
    );
  }
}
