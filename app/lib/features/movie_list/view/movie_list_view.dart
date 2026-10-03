import 'package:cine_vault/core/ui.dart';
import 'package:cine_vault/core/widgets/movie_ui/movie_ui.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/movie_list/bloc/movie_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The "see all" UI for one [category]. Sends events to [MovieListBloc] and
/// reports taps through the callbacks, so it never navigates by itself.
class MovieListView extends StatelessWidget {
  const MovieListView({
    required this.category,
    required this.favoriteButton,
    required this.onBack,
    required this.onMovieTap,
    super.key,
  });

  final MovieCategory category;
  final FavoriteButtonBuilder favoriteButton;
  final VoidCallback onBack;
  final void Function(Movie movie, String heroTag) onMovieTap;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MovieListBloc>();
    return BlocBuilder<MovieListBloc, MovieListState>(
      builder: (context, state) => _MovieListBody(
        category: category,
        state: state,
        favoriteButton: favoriteButton,
        onBack: onBack,
        onRetry: () => bloc.add(const MovieListEvent.retried()),
        onLoadMore: () => bloc.add(const MovieListEvent.loadMoreRequested()),
        onMovieTap: onMovieTap,
      ),
    );
  }
}

/// Draws one [MovieListState].
class _MovieListBody extends StatelessWidget {
  const _MovieListBody({
    required this.category,
    required this.state,
    required this.favoriteButton,
    required this.onBack,
    required this.onRetry,
    required this.onLoadMore,
    required this.onMovieTap,
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
          heroTagPrefix: '${category.name}_list',
          favoriteButton: favoriteButton,
          onMovieTap: onMovieTap,
          isLoadingMore: isLoadingMore,
          onLoadMore: hasReachedMax ? null : onLoadMore,
        ),
      },
    );
  }
}
