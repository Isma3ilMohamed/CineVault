import 'package:cached_network_image/cached_network_image.dart';
import 'package:cine_vault/core/extensions/tmdb_display.dart';
import 'package:cine_vault/features/favorites/presentation/widgets/favorite_heart_button.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _maybeWrapHero(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    SizedBox(
                      width: width,
                      height: height,
                      child: movie.fullPosterUrl != null
                          ? CachedNetworkImage(
                              imageUrl: movie.fullPosterUrl!,
                              fit: BoxFit.cover,
                              placeholder: (_, _) => _buildShimmer(),
                              errorWidget: (_, _, _) => _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                    Positioned(top: 6, left: 6, child: FavoriteHeartButton(movie: movie, size: 18)),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 14),
                            const SizedBox(width: 2),
                            Text(
                              movie.formattedRating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Flexible so a narrow parent ellipsizes the title instead of overflowing.
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    movie.releaseYear,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _maybeWrapHero({required Widget child}) {
    if (heroTag == null) return child;
    return Hero(tag: heroTag!, child: child);
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(color: Colors.grey[800]),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[900],
      child: const Center(child: Icon(Icons.movie_outlined, color: Colors.white24, size: 40)),
    );
  }
}
