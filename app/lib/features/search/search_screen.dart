import 'package:cine_vault/core/widgets/movie_ui/movie_ui.dart';
import 'package:cine_vault/features/search/search_bloc.dart';
import 'package:cine_vault/features/search/search_content.dart';
import 'package:cine_vault/features/search/search_contract.dart';
import 'package:cine_vault/features/search/search_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Binds the bloc to [SearchContent].
class SearchScreen extends StatelessWidget {
  const SearchScreen({required this.favoriteButton, required this.onNavigation, super.key});

  final FavoriteButtonBuilder favoriteButton;
  final ValueChanged<SearchNavigation> onNavigation;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) => SearchContent(
        state: state,
        favoriteButton: favoriteButton,
        onBack: () => onNavigation(const NavigateBack()),
        onQueryChanged: (query) => bloc.add(SearchEvent.queryChanged(query)),
        onCleared: () => bloc.add(const SearchEvent.cleared()),
        onRecentTap: (query) => bloc.add(SearchEvent.recentSearchTapped(query)),
        onClearRecents: () => bloc.add(const SearchEvent.recentSearchesCleared()),
        onRetry: () => bloc.add(const SearchEvent.retried()),
        onLoadMore: () => bloc.add(const SearchEvent.loadMoreRequested()),
        onMovieTap: (movie, heroTag) =>
            onNavigation(OpenMovie(movieId: movie.id, heroTag: heroTag)),
      ),
    );
  }
}
