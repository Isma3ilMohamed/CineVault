import 'package:favorites/src/favorite_button.dart';
import 'package:favorites/src/favorites_bloc.dart';
import 'package:favorites/src/favorites_content.dart';
import 'package:favorites/src/favorites_contract.dart';
import 'package:favorites/src/favorites_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Binds the bloc to [FavoritesContent].
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({required this.onNavigation, super.key});

  final ValueChanged<FavoritesNavigation> onNavigation;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) => FavoritesContent(
        state: state,
        // Same feature, so the real button is used directly instead of a slot.
        favoriteButton: (_, movie, size) => FavoriteButton(movie: movie, size: size),
        onMovieTap: (movie, heroTag) =>
            onNavigation(OpenMovie(movieId: movie.id, heroTag: heroTag)),
        onSearch: () => onNavigation(const OpenSearch()),
      ),
    );
  }
}
