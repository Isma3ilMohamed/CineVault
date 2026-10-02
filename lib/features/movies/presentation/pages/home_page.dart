import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_category.dart';
import '../bloc/movies_bloc.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/movies_section.dart';

/// ببساطة كدا: ده الـ Home screen
/// أول حاجة بيفتحها المستخدم
/// بيعرض carousel + 4 sections من الأفلام
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// بنبعت الـ heroTag في الـ extra عشان الـ details page يستخدمه في الـ Hero
  /// لو الفيلم في أكتر من section، كل card بياخد tag مختلف
  void _openDetails(BuildContext context, Movie movie, String heroTag) {
    context.push('/movie/${movie.id}', extra: {'heroTag': heroTag});
  }

  void _openSeeAll(BuildContext context, MovieCategory category) {
    context.push('/list/${category.slug}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          return switch (state) {
            MoviesInitial() => _buildInitial(context),
            MoviesLoading() => _buildLoading(),
            MoviesError(:final message) => _buildError(context, message),
            MoviesLoaded() => _buildLoaded(context, state),
          };
        },
      ),
    );
  }

  Widget _buildInitial(BuildContext context) {
    // Auto-trigger loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MoviesBloc>().add(const LoadHomeMovies());
    });
    return _buildLoading();
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFFE50914)),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: onSurface.withValues(alpha: 0.55),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<MoviesBloc>().add(const LoadHomeMovies());
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context).tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, MoviesLoaded state) {
    final l10n = AppLocalizations.of(context);
    return RefreshIndicator(
      color: const Color(0xFFE50914),
      onRefresh: () async {
        context.read<MoviesBloc>().add(const RefreshHomeMovies());
      },
      child: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            floating: true,
            title: const Text(
              'CineVault',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFE50914),
                letterSpacing: 1.2,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () => context.push('/search'),
              ),
            ],
          ),
          // Carousel — كل section ليه prefix فريد عشان الـ Hero tags ما تتعارضش
          SliverToBoxAdapter(
            child: FeaturedCarousel(
              movies: state.popularMovies,
              heroTagPrefix: 'carousel',
              onMovieTap: (movie, heroTag) => _openDetails(context, movie, heroTag),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          // Sections
          SliverToBoxAdapter(
            child: MoviesSection(
              title: l10n.sectionTrending,
              movies: state.trendingDayMovies,
              heroTagPrefix: 'trending',
              onMovieTap: (movie, heroTag) => _openDetails(context, movie, heroTag),
              onSeeAll: () => _openSeeAll(context, MovieCategory.trending),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: MoviesSection(
              title: l10n.sectionPopular,
              movies: state.popularMovies,
              heroTagPrefix: 'popular',
              onMovieTap: (movie, heroTag) => _openDetails(context, movie, heroTag),
              onSeeAll: () => _openSeeAll(context, MovieCategory.popular),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: MoviesSection(
              title: l10n.sectionTopRated,
              movies: state.topRatedMovies,
              heroTagPrefix: 'top_rated',
              onMovieTap: (movie, heroTag) => _openDetails(context, movie, heroTag),
              onSeeAll: () => _openSeeAll(context, MovieCategory.topRated),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: MoviesSection(
              title: l10n.sectionNowPlaying,
              movies: state.nowPlayingMovies,
              heroTagPrefix: 'now_playing',
              onMovieTap: (movie, heroTag) => _openDetails(context, movie, heroTag),
              onSeeAll: () => _openSeeAll(context, MovieCategory.nowPlaying),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: MoviesSection(
              title: l10n.sectionUpcoming,
              movies: state.upcomingMovies,
              heroTagPrefix: 'upcoming',
              onMovieTap: (movie, heroTag) => _openDetails(context, movie, heroTag),
              onSeeAll: () => _openSeeAll(context, MovieCategory.upcoming),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
