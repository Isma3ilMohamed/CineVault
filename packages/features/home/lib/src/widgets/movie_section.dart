import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:home/src/l10n/generated/home_localizations.dart';
import 'package:movie_ui/movie_ui.dart';

/// Titled horizontal row of movies with a "See all" action.
class MovieSection extends StatelessWidget {
  const MovieSection({
    required this.title,
    required this.movies,
    required this.heroTagPrefix,
    required this.favoriteButton,
    required this.onMovieTap,
    required this.onSeeAll,
    super.key,
  });

  final String title;
  final List<Movie> movies;

  /// Must differ from other rows on the screen to avoid Hero tag collisions.
  final String heroTagPrefix;
  final FavoriteButtonBuilder favoriteButton;
  final void Function(Movie movie, String heroTag) onMovieTap;
  final VoidCallback onSeeAll;

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
              Flexible(child: SectionTitle(title)),
              TextButton(
                onPressed: onSeeAll,
                child: Text(
                  HomeLocalizations.of(context).homeSeeAll,
                  style: TextStyle(color: context.appColors.brand, fontWeight: FontWeight.w600),
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
                favoriteButton: favoriteButton,
                heroTag: heroTag,
                onTap: () => onMovieTap(movie, heroTag),
              );
            },
          ),
        ),
      ],
    );
  }
}
