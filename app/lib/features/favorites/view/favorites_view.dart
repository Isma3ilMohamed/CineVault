import 'package:cine_vault/core/ui.dart';
import 'package:cine_vault/core/widgets/movie_ui/movie_ui.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/favorites/bloc/favorites_bloc.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The favorites screen UI. Reports taps through the callbacks, so it never
/// navigates by itself.
class FavoritesView extends StatelessWidget {
  const FavoritesView({
    required this.favoriteButton,
    required this.onMovieTap,
    required this.onSearch,
    super.key,
  });

  final FavoriteButtonBuilder favoriteButton;
  final void Function(Movie movie, String heroTag) onMovieTap;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) => _FavoritesBody(
        state: state,
        favoriteButton: favoriteButton,
        onMovieTap: onMovieTap,
        onSearch: onSearch,
      ),
    );
  }
}

/// Draws one [FavoritesState].
class _FavoritesBody extends StatelessWidget {
  const _FavoritesBody({
    required this.state,
    required this.favoriteButton,
    required this.onMovieTap,
    required this.onSearch,
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
          AppLocalizations.of(context).favoritesTitle,
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
    final l10n = AppLocalizations.of(context);
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
