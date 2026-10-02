import 'package:cine_vault/features/movies/domain/entities/movie.dart';
import 'package:cine_vault/features/movies/domain/entities/movie_category.dart';
import 'package:cine_vault/features/movies/presentation/bloc/movie_list_bloc.dart';
import 'package:cine_vault/features/movies/presentation/widgets/movie_card.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MovieListPage extends StatelessWidget {
  const MovieListPage({required this.category, super.key});
  final MovieCategory category;

  String _titleFor(AppLocalizations l10n) {
    return switch (category) {
      MovieCategory.trending => l10n.sectionTrending,
      MovieCategory.popular => l10n.sectionPopular,
      MovieCategory.topRated => l10n.sectionTopRated,
      MovieCategory.nowPlaying => l10n.sectionNowPlaying,
      MovieCategory.upcoming => l10n.sectionUpcoming,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(_titleFor(l10n)),
      ),
      body: BlocBuilder<MovieListBloc, MovieListState>(
        builder: (context, state) {
          return switch (state) {
            MovieListInitial() || MovieListLoading() => const Center(
              child: CircularProgressIndicator(color: Color(0xFFE50914)),
            ),
            MovieListError(:final message) => _ErrorView(
              message: message,
              onRetry: () => context.read<MovieListBloc>().add(const MovieListRetried()),
            ),
            MovieListLoaded(:final movies, :final isLoadingMore, :final hasReachedMax) => _Grid(
              movies: movies,
              isLoadingMore: isLoadingMore,
              hasReachedMax: hasReachedMax,
              category: category,
            ),
          };
        },
      ),
    );
  }
}

class _Grid extends StatefulWidget {
  const _Grid({
    required this.movies,
    required this.isLoadingMore,
    required this.hasReachedMax,
    required this.category,
  });
  final List<Movie> movies;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final MovieCategory category;

  @override
  State<_Grid> createState() => _GridState();
}

class _GridState extends State<_Grid> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final cur = _scrollController.position.pixels;
    if (cur >= max * 0.8 && !widget.isLoadingMore && !widget.hasReachedMax) {
      context.read<MovieListBloc>().add(const MovieListLoadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 0.55,
            ),
            delegate: SliverChildBuilderDelegate((context, i) {
              final movie = widget.movies[i];
              final heroTag = '${widget.category.slug}_list_${movie.id}';
              return MovieCard(
                movie: movie,
                width: double.infinity,
                height: 260,
                heroTag: heroTag,
                onTap: () => context.push('/movie/${movie.id}', extra: {'heroTag': heroTag}),
              );
            }, childCount: widget.movies.length),
          ),
        ),
        if (widget.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Center(child: CircularProgressIndicator(color: Color(0xFFE50914))),
            ),
          ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: onSurface.withValues(alpha: 0.55)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: onSurface.withValues(alpha: 0.7), fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
