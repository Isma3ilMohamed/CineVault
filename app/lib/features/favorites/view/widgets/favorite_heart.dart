import 'package:cine_vault/core/constants/app_durations.dart';
import 'package:cine_vault/core/ui.dart';
import 'package:flutter/material.dart';

/// Filled or outlined heart on a dark circle, animating between the two.
class FavoriteHeart extends StatelessWidget {
  const FavoriteHeart({required this.isFavorite, required this.onTap, super.key, this.size = 22});

  final bool isFavorite;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: AnimatedSwitcher(
            duration: AppDurations.favoriteToggle,
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(isFavorite),
              color: isFavorite ? context.appColors.brand : Colors.white,
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}
