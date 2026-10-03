import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:favorites/src/favorites_contract.dart';
import 'package:favorites/src/l10n/generated/favorites_localizations.dart';
import 'package:flutter/material.dart';
import 'package:movie_ui/movie_ui.dart';

/// Pure UI for every [FavoritesState].
class FavoritesContent extends StatelessWidget {
  const FavoritesContent({
    required this.state,
    required this.favoriteButton,
    required this.onMovieTap,
    required this.onSearch,
    super.key,
  });

  final FavoritesState state;
  final FavoriteButtonBuilder favoriteButton;
  final void Function(Movie movie, String heroTag) onMovieTap;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final brand = context.appColors.brand;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FavoritesLocalizations.of(context).favoritesTitle,
          style: TextStyle(fontWeight: FontWeight.bold, color: brand, letterSpacing: 1.2),
        ),
      ),
      body: switch (state) {
        FavoritesInitial() => Center(child: CircularProgressIndicator(color: brand)),
        FavoritesLoaded(:final movies) when movies.isEmpty => _EmptyFavorites(onSearch: onSearch),
        FavoritesLoaded(:final movies) => MovieGrid(
          movies: movies,
          heroTagPrefix: 'favorites',
          favoriteButton: favoriteButton,
          onMovieTap: onMovieTap,
        ),
      },
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites({required this.onSearch});

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final l10n = FavoritesLocalizations.of(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border_rounded, size: 72, color: onSurface.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(
              l10n.favoritesEmptyTitle,
              style: TextStyle(color: onSurface.withValues(alpha: 0.7), fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onSearch,
              icon: const Icon(Icons.search_rounded),
              label: Text(l10n.favoritesEmptyCta),
            ),
          ],
        ),
      ),
    );
  }
}
