import 'package:cine_vault/features/favorites/presentation/cubit/favorite_ids_cubit.dart';
import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteHeartButton extends StatelessWidget {
  const FavoriteHeartButton({
    required this.movie,
    super.key,
    this.size = 22,
    this.withBackground = true,
  });
  final Movie movie;
  final double size;
  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoriteIdsCubit, bool>(
      (cubit) => cubit.state.contains(movie.id),
    );

    final icon = AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
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
      child: Padding(padding: const EdgeInsets.all(6), child: icon),
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
