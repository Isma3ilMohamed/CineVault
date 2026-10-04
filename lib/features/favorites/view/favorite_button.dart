import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/favorites/cubit/favorite_ids_cubit.dart';
import 'package:cine_vault/features/favorites/view/widgets/favorite_heart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The heart toggle for [movie], bound to the app-wide [FavoriteIdsCubit].
///
/// Each screen's page passes it into the shared movie widgets'
/// `FavoriteButtonBuilder` slot (tests pass a plain icon instead).
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({required this.movie, super.key, this.size = 22});

  final Movie movie;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoriteIdsCubit, bool>(
      (cubit) => cubit.state.contains(movie.id),
    );
    return FavoriteHeart(
      isFavorite: isFavorite,
      size: size,
      onTap: () => context.read<FavoriteIdsCubit>().toggle(movie),
    );
  }
}
