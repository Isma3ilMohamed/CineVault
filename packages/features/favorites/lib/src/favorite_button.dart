import 'package:domain/domain.dart';
import 'package:favorites/src/favorite_ids_cubit.dart';
import 'package:favorites/src/widgets/favorite_heart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The heart toggle for [movie], bound to the app-wide [FavoriteIdsCubit].
///
/// Other features never import this: they take a `FavoriteButtonBuilder` and
/// the navigation layer passes this widget into it.
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
