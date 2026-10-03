import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list/src/movie_list_bloc.dart';
import 'package:movie_list/src/movie_list_content.dart';
import 'package:movie_list/src/movie_list_contract.dart';
import 'package:movie_list/src/movie_list_navigation.dart';
import 'package:movie_ui/movie_ui.dart';

/// Binds the bloc to [MovieListContent].
class MovieListScreen extends StatelessWidget {
  const MovieListScreen({
    required this.category,
    required this.favoriteButton,
    required this.onNavigation,
    super.key,
  });

  final MovieCategory category;
  final FavoriteButtonBuilder favoriteButton;
  final ValueChanged<MovieListNavigation> onNavigation;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MovieListBloc>();
    return BlocBuilder<MovieListBloc, MovieListState>(
      builder: (context, state) => MovieListContent(
        category: category,
        state: state,
        favoriteButton: favoriteButton,
        onBack: () => onNavigation(const NavigateBack()),
        onRetry: () => bloc.add(const MovieListEvent.retried()),
        onLoadMore: () => bloc.add(const MovieListEvent.loadMoreRequested()),
        onMovieTap: (movie, heroTag) =>
            onNavigation(OpenMovie(movieId: movie.id, heroTag: heroTag)),
      ),
    );
  }
}
