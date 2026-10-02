import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../favorites/presentation/widgets/favorite_heart_button.dart';
import '../../domain/entities/movie.dart';

/// ببساطة كدا: Widget صغير قابل لإعادة الاستخدام
/// بيظهر poster الفيلم + الـ rating + العنوان
/// بنستخدمه في الـ Home, Search, Favorites
class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final double width;
  final double height;

  /// Optional tag للـ Hero animation.
  /// لو الكارت بيظهر أكتر من مرة في نفس الصفحة (فيلم في Popular و Top Rated)
  /// لازم كل instance يكون ليه tag فريد. خليها null لو مش عايز Hero خالص.
  final String? heroTag;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.width = 140,
    this.height = 210,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
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
                              placeholder: (_, __) => _buildShimmer(),
                              errorWidget: (_, __, ___) => _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                    // Favorite heart (top-left)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: FavoriteHeartButton(movie: movie, size: 18),
                    ),
                    // Rating badge (top-right)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFB800),
                              size: 14,
                            ),
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
            // Text area — Flexible عشان لو الـ parent ضيّق الـ title يقطع بـ ellipsis
            // بدل ما الـ Column يعمل RenderFlex overflow
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
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
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

  /// لو heroTag = null مش هنعمل Hero خالص (عشان ما يحصلش duplicate tag).
  /// لو فيه tag، بنلفه حوالين الـ child.
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
      child: const Center(
        child: Icon(
          Icons.movie_outlined,
          color: Colors.white24,
          size: 40,
        ),
      ),
    );
  }
}
