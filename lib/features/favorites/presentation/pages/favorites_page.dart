import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/presentation/widgets/movie_card.dart';
import '../bloc/favorites_bloc.dart';

/// ببساطة كدا: صفحة الـ Favorites
/// - Subscribed → reactive stream من Hive
/// - Empty state لو مفيش أفلام
/// - Grid 2 cols + scroll
///
/// ملاحظة: مفيش pagination — كل الـ favorites بتتحمل دفعة واحدة
/// (عادةً عدد قليل وكلها offline)
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).favoritesTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFE50914),
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          return switch (state) {
            FavoritesInitial() => const Center(
                child: CircularProgressIndicator(color: Color(0xFFE50914)),
              ),
            FavoritesLoaded(:final movies) when movies.isEmpty =>
              const _EmptyFavorites(),
            FavoritesLoaded(:final movies) => _FavoritesGrid(movies: movies),
          };
        },
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  final List<Movie> movies;

  const _FavoritesGrid({required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.55,
      ),
      itemBuilder: (context, i) {
        final movie = movies[i];
        final heroTag = 'favorites_${movie.id}';
        return MovieCard(
          movie: movie,
          width: double.infinity,
          height: 260,
          heroTag: heroTag,
          onTap: () => context.push(
            '/movie/${movie.id}',
            extra: {'heroTag': heroTag},
          ),
        );
      },
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

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
            Icon(
              Icons.favorite_border_rounded,
              size: 72,
              color: onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.favoritesEmptyTitle,
              style: TextStyle(
                color: onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/search'),
              icon: const Icon(Icons.search_rounded),
              label: Text(l10n.favoritesEmptyCta),
            ),
          ],
        ),
      ),
    );
  }
}
