import 'package:flutter/material.dart';

import '../../../movies/domain/entities/movie.dart';
import '../../../movies/presentation/widgets/movie_card.dart';

class SearchResultsGrid extends StatefulWidget {
  final List<Movie> movies;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final VoidCallback onLoadMore;
  final void Function(Movie movie, String heroTag) onMovieTap;

  const SearchResultsGrid({
    super.key,
    required this.movies,
    required this.isLoadingMore,
    required this.hasReachedMax,
    required this.onLoadMore,
    required this.onMovieTap,
  });

  @override
  State<SearchResultsGrid> createState() => _SearchResultsGridState();
}

class _SearchResultsGridState extends State<SearchResultsGrid> {
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
    final current = _scrollController.position.pixels;
    if (current >= max * 0.8 &&
        !widget.isLoadingMore &&
        !widget.hasReachedMax) {
      widget.onLoadMore();
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
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final movie = widget.movies[i];
                final heroTag = 'search_${movie.id}';
                return MovieCard(
                  movie: movie,
                  width: double.infinity,
                  height: 260,
                  heroTag: heroTag,
                  onTap: () => widget.onMovieTap(movie, heroTag),
                );
              },
              childCount: widget.movies.length,
            ),
          ),
        ),
        if (widget.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFE50914)),
              ),
            ),
          ),
      ],
    );
  }
}
