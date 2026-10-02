import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:cine_vault/features/movies/presentation/widgets/movie_card.dart';
import 'package:flutter/material.dart';

class MoviesSection extends StatelessWidget {
  const MoviesSection({
    required this.title,
    required this.movies,
    required this.heroTagPrefix,
    super.key,
    this.onSeeAll,
    this.onMovieTap,
  });
  final String title;
  final List<Movie> movies;
  final VoidCallback? onSeeAll;

  final void Function(Movie movie, String heroTag)? onMovieTap;

  /// Must differ from other sections on the same page to avoid Hero tag collisions.
  final String heroTagPrefix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: const Text(
                    'See All',
                    style: TextStyle(color: Color(0xFFE50914), fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // 290 leaves room for two-line titles under larger text scaling.
        SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final movie = movies[index];
              final heroTag = '${heroTagPrefix}_${movie.id}';
              return MovieCard(
                movie: movie,
                heroTag: heroTag,
                onTap: () => onMovieTap?.call(movie, heroTag),
              );
            },
          ),
        ),
      ],
    );
  }
}
