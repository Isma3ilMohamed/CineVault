import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';

class FeaturedCarousel extends StatelessWidget {
  final List<Movie> movies;

  final void Function(Movie movie, String heroTag)? onMovieTap;

  /// Must be unique on the screen so Hero tags do not collide with other sections.
  final String heroTagPrefix;

  const FeaturedCarousel({
    super.key,
    required this.movies,
    this.onMovieTap,
    this.heroTagPrefix = 'carousel',
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    final featured = movies.take(5).toList();

    return CarouselSlider.builder(
      itemCount: featured.length,
      itemBuilder: (context, index, _) {
        final movie = featured[index];
        final heroTag = '${heroTagPrefix}_${movie.id}';
        return _buildCarouselItem(movie, heroTag);
      },
      options: CarouselOptions(
        height: 280,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  Widget _buildCarouselItem(Movie movie, String heroTag) {
    return GestureDetector(
      onTap: () => onMovieTap?.call(movie, heroTag),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: heroTag,
            child: movie.fullBackdropUrl != null
                ? CachedNetworkImage(
                    imageUrl: movie.fullBackdropUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        Container(color: Colors.grey[900]),
                  )
                : Container(color: Colors.grey[900]),
          ),

          Container(
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

          Positioned(
            left: 16,
            right: 16,
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
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFB800),
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      movie.formattedRating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      movie.releaseYear,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
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
