import 'package:cine_vault/core/widgets/movie_ui/movie_ui.dart';
import 'package:cine_vault/features/home/home_contract.dart';
import 'package:cine_vault/features/home/l10n/generated/home_localizations.dart';
import 'package:cine_vault/features/home/widgets/featured_carousel.dart';
import 'package:cine_vault/features/home/widgets/movie_section.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

/// Pure UI for every [HomeState].
class HomeContent extends StatelessWidget {
  const HomeContent({
    required this.state,
    required this.favoriteButton,
    required this.onRetry,
    required this.onRefresh,
    required this.onMovieTap,
    required this.onSeeAll,
    required this.onSearch,
    super.key,
  });

  final HomeState state;
  final FavoriteButtonBuilder favoriteButton;
  final VoidCallback onRetry;

  /// Completes when the refresh is done, so the indicator can close.
  final Future<void> Function() onRefresh;
  final void Function(Movie movie, String heroTag) onMovieTap;
  final ValueChanged<MovieCategory> onSeeAll;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (state) {
        HomeInitial() ||
        HomeLoading() => Center(child: CircularProgressIndicator(color: context.appColors.brand)),
        HomeError(:final failure) => ErrorView(
          message: failure.localizedMessage(context),
          retryLabel: CoreUiLocalizations.of(context).tryAgain,
          onRetry: onRetry,
        ),
        HomeLoaded(:final sections) => _LoadedBody(
          sections: sections,
          favoriteButton: favoriteButton,
          onRefresh: onRefresh,
          onMovieTap: onMovieTap,
          onSeeAll: onSeeAll,
          onSearch: onSearch,
        ),
      },
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({
    required this.sections,
    required this.favoriteButton,
    required this.onRefresh,
    required this.onMovieTap,
    required this.onSeeAll,
    required this.onSearch,
  });

  final Map<MovieCategory, List<Movie>> sections;
  final FavoriteButtonBuilder favoriteButton;
  final Future<void> Function() onRefresh;
  final void Function(Movie movie, String heroTag) onMovieTap;
  final ValueChanged<MovieCategory> onSeeAll;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final brand = context.appColors.brand;
    return RefreshIndicator(
      color: brand,
      onRefresh: onRefresh,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text(
              'CineVault',
              style: TextStyle(fontWeight: FontWeight.bold, color: brand, letterSpacing: 1.2),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: HomeLocalizations.of(context).homeSearch,
                onPressed: onSearch,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: FeaturedCarousel(
              movies: sections[MovieCategory.popular] ?? const [],
              onMovieTap: onMovieTap,
            ),
          ),
          // Rows in enum order; each one has its own Hero tag prefix.
          for (final category in MovieCategory.values)
            SliverPadding(
              padding: const EdgeInsets.only(top: 24),
              sliver: SliverToBoxAdapter(
                child: MovieSection(
                  title: category.label(context),
                  movies: sections[category] ?? const [],
                  heroTagPrefix: category.name,
                  favoriteButton: favoriteButton,
                  onMovieTap: onMovieTap,
                  onSeeAll: () => onSeeAll(category),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
