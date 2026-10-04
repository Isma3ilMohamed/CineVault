import 'package:carousel_slider/carousel_slider.dart';
import 'package:cine_vault/core/constants/app_durations.dart';
import 'package:cine_vault/core/ui.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Auto-playing backdrop carousel of the first five [movies].
class FeaturedCarousel extends StatelessWidget {
  const FeaturedCarousel({required this.movies, required this.onMovieTap, super.key});

  static const _heroTagPrefix = 'carousel';
  static const _maxItems = 5;

  final List<Movie> movies;
  final void Function(Movie movie, String heroTag) onMovieTap;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();
    final featured = movies.take(_maxItems).toList();

    return CarouselSlider.builder(
      itemCount: featured.length,
      itemBuilder: (context, index, _) {
        final movie = featured[index];
        final heroTag = '${_heroTagPrefix}_${movie.id}';
        return _CarouselItem(
          movie: movie,
          heroTag: heroTag,
          onTap: () => onMovieTap(movie, heroTag),
        );
      },
      options: CarouselOptions(
        height: 280,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: AppDurations.carouselAutoPlay,
      ),
    );
  }
}

class _CarouselItem extends StatelessWidget {
  const _CarouselItem({required this.movie, required this.heroTag, required this.onTap});

  final Movie movie;
  final String heroTag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final year = MovieFormat.year(movie.releaseDate) ?? AppLocalizations.of(context).notAvailable;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: heroTag,
            child: RemoteImage(
              url: TmdbImages.backdrop(movie.backdropPath),
              sourceAspectRatio: TmdbImages.backdropAspectRatio,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.9),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          PositionedDirectional(
            start: 16,
            end: 16,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: context.appColors.rating, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      MovieFormat.rating(movie.voteAverage),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 12),
                    Text(year, style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
