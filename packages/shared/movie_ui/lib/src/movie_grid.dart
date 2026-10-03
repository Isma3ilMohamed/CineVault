import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:movie_ui/src/favorite_button_builder.dart';
import 'package:movie_ui/src/movie_card.dart';

/// Two-column grid of [MovieCard]s with optional infinite scroll.
///
/// [onLoadMore] is called when the user scrolls near the end, unless
/// [isLoadingMore] is true. Pass null when there is nothing more to load.
class MovieGrid extends StatefulWidget {
  const MovieGrid({
    required this.movies,
    required this.heroTagPrefix,
    required this.favoriteButton,
    required this.onMovieTap,
    super.key,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  final List<Movie> movies;

  /// Hero tags are `'<prefix>_<movieId>'`; must differ from other lists that
  /// can be on screen during the same transition.
  final String heroTagPrefix;
  final FavoriteButtonBuilder favoriteButton;
  final void Function(Movie movie, String heroTag) onMovieTap;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  @override
  State<MovieGrid> createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {
  static const _loadMoreThreshold = 0.8;

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
    final onLoadMore = widget.onLoadMore;
    if (onLoadMore == null || widget.isLoadingMore || !_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent * _loadMoreThreshold) onLoadMore();
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
              final heroTag = '${widget.heroTagPrefix}_${movie.id}';
              return MovieCard(
                movie: movie,
                favoriteButton: widget.favoriteButton,
                width: double.infinity,
                height: 260,
                heroTag: heroTag,
                onTap: () => widget.onMovieTap(movie, heroTag),
              );
            }, childCount: widget.movies.length),
          ),
        ),
        if (widget.isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Center(child: CircularProgressIndicator(color: context.appColors.brand)),
            ),
          ),
      ],
    );
  }
}
