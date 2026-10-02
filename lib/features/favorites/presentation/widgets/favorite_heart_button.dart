import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../movies/domain/entities/movie.dart';
import '../cubit/favorite_ids_cubit.dart';

/// ببساطة كدا: زرار القلب
/// - بيقرا الحالة من FavoriteIdsCubit عبر context.select (minimal rebuild)
/// - بيدوس → FavoriteIdsCubit.toggle → stream → UI يـ rebuild
///
/// Variants:
///   - small (default): للـ MovieCard overlay
///   - large: للـ MovieDetailsPage AppBar action
class FavoriteHeartButton extends StatelessWidget {
  final Movie movie;
  final double size;
  final bool withBackground;

  const FavoriteHeartButton({
    super.key,
    required this.movie,
    this.size = 22,
    this.withBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    // select: نعيد build بس لما الـ id بتاعنا يدخل/يخرج من الـ set
    final isFavorite = context.select<FavoriteIdsCubit, bool>(
      (cubit) => cubit.state.contains(movie.id),
    );

    final icon = AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Icon(
        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        key: ValueKey(isFavorite),
        color: isFavorite ? const Color(0xFFE50914) : Colors.white,
        size: size,
      ),
    );

    final tappable = InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => context.read<FavoriteIdsCubit>().toggle(movie),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: icon,
      ),
    );

    if (!withBackground) return tappable;

    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: tappable,
    );
  }
}
