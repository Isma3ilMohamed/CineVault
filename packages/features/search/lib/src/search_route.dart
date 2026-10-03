import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_ui/movie_ui.dart';
import 'package:search/src/search_bloc.dart';
import 'package:search/src/search_contract.dart';
import 'package:search/src/search_navigation.dart';
import 'package:search/src/search_screen.dart';

/// Entry and exit point of the search screen.
class SearchRoute extends StatelessWidget {
  const SearchRoute({
    required this.onBack,
    required this.onOpenMovie,
    required this.favoriteButton,
    super.key,
  });

  final VoidCallback onBack;
  final void Function(int movieId, String heroTag) onOpenMovie;
  final FavoriteButtonBuilder favoriteButton;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SearchBloc>()..add(const SearchEvent.started()),
      child: SearchScreen(
        favoriteButton: favoriteButton,
        onNavigation: (navigation) => switch (navigation) {
          NavigateBack() => onBack(),
          OpenMovie(:final movieId, :final heroTag) => onOpenMovie(movieId, heroTag),
        },
      ),
    );
  }
}
