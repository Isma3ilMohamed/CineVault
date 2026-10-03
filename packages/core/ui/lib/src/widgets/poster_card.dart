import 'package:core_ui/src/theme/app_colors.dart';
import 'package:core_ui/src/widgets/remote_image.dart';
import 'package:flutter/material.dart';

/// Poster with a rating badge, title and year: the card used by every movie list.
///
/// Takes plain values rather than a `Movie` so the design system stays free of
/// domain types. [leading] is a slot over the top-start corner (the favorite
/// button), filled by whoever owns that feature.
class PosterCard extends StatelessWidget {
  const PosterCard({
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.year,
    super.key,
    this.onTap,
    this.heroTag,
    this.leading,
    this.width = 140,
    this.height = 210,
  });

  final String title;
  final String? posterUrl;
  final String rating;
  final String year;
  final VoidCallback? onTap;

  /// Must be unique on the screen when the same movie can appear more than once;
  /// null disables the Hero.
  final String? heroTag;
  final Widget? leading;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final poster = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            RemoteImage(url: posterUrl),
            if (leading case final leading?)
              PositionedDirectional(top: 6, start: 6, child: leading),
            PositionedDirectional(top: 8, end: 8, child: _RatingBadge(rating: rating)),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (heroTag case final tag?) Hero(tag: tag, child: poster) else poster,
            const SizedBox(height: 8),
            // Flexible so a narrow parent ellipsizes the title instead of overflowing.
            Flexible(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface),
              ),
            ),
            const SizedBox(height: 2),
            Text(year, style: TextStyle(fontSize: 12, color: onSurface.withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: context.appColors.rating, size: 14),
          const SizedBox(width: 2),
          Text(
            rating,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
