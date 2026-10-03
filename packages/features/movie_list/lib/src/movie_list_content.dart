import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:movie_list/src/movie_list_contract.dart';
import 'package:movie_ui/movie_ui.dart';

/// Pure UI for every [MovieListState].
class MovieListContent extends StatelessWidget {
  const MovieListContent({
    required this.category,
    required this.state,
    required this.favoriteButton,
    required this.onBack,
    required this.onRetry,
    required this.onLoadMore,
    required this.onMovieTap,
    super.key,
  });

  final MovieCategory category;
  final MovieListState state;
  final FavoriteButtonBuilder favoriteButton;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final void Function(Movie movie, String heroTag) onMovieTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: onBack),
        title: Text(category.label(context)),
      ),
      body: switch (state) {
        MovieListInitial() || MovieListLoading() => Center(
          child: CircularProgressIndicator(color: context.appColors.brand),
        ),
        MovieListError(:final failure) => ErrorView(
          message: failure.localizedMessage(context),
          retryLabel: CoreUiLocalizations.of(context).tryAgain,
          onRetry: onRetry,
        ),
        MovieListLoaded(:final movies, :final isLoadingMore, :final hasReachedMax) => MovieGrid(
          movies: movies,
          heroTagPrefix: '${category.slug}_list',
          favoriteButton: favoriteButton,
          onMovieTap: onMovieTap,
          isLoadingMore: isLoadingMore,
          onLoadMore: hasReachedMax ? null : onLoadMore,
        ),
      },
    );
  }
}
