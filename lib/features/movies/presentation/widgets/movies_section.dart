import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';
import 'movie_card.dart';

/// Section من الأفلام (horizontal scroll)
/// بيتستخدم في Home screen لعرض Popular/Top Rated/Upcoming
class MoviesSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final VoidCallback? onSeeAll;

  /// بناخد الـ tag كمان عشان نبعته للـ details page كـ extra
  /// وبنبنيه من prefix عشان نتفادى collision لو الفيلم في أكتر من section
  final void Function(Movie movie, String heroTag)? onMovieTap;

  /// Prefix لكل Hero tag في الـ section
  /// لازم يكون مختلف عن باقي الـ sections في نفس الصفحة
  final String heroTagPrefix;

  const MoviesSection({
    super.key,
    required this.title,
    required this.movies,
    required this.heroTagPrefix,
    this.onSeeAll,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
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
                    style: TextStyle(
                      color: Color(0xFFE50914),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Horizontal list — 290 عشان 2-line titles ترتاح مع text scaling
        SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
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
