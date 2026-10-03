import 'package:cine_vault/core/widgets/movie_ui/movie_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

/// Horizontal row of similar movies, each with the favorite toggle.
class SimilarMoviesRow extends StatelessWidget {
  const SimilarMoviesRow({
    required this.movies,
    required this.favoriteButton,
    required this.onMovieTap,
    super.key,
  });

  final List<Movie> movies;
  final FavoriteButtonBuilder favoriteButton;
  final void Function(Movie movie, String heroTag) onMovieTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final movie = movies[i];
          // Distinct prefix so tags do not collide with Hero tags on the pushed route.
          final tag = 'similar_${movie.id}';
          return MovieCard(
            movie: movie,
            favoriteButton: favoriteButton,
            heroTag: tag,
            onTap: () => onMovieTap(movie, tag),
          );
        },
      ),
    );
  }
}
