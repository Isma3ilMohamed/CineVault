import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_list/src/movie_list_bloc.dart';
import 'package:movie_list/src/movie_list_contract.dart';
import 'package:movie_list/src/movie_list_navigation.dart';
import 'package:movie_list/src/movie_list_screen.dart';
import 'package:movie_ui/movie_ui.dart';

/// Entry and exit point of the "see all" list for one [category].
class MovieListRoute extends StatelessWidget {
  const MovieListRoute({
    required this.category,
    required this.onBack,
    required this.onOpenMovie,
    required this.favoriteButton,
    super.key,
  });

  final MovieCategory category;
  final VoidCallback onBack;
  final void Function(int movieId, String heroTag) onOpenMovie;
  final FavoriteButtonBuilder favoriteButton;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<MovieListBloc>(param1: category)..add(const MovieListEvent.started()),
      child: MovieListScreen(
        category: category,
        favoriteButton: favoriteButton,
        onNavigation: (navigation) => switch (navigation) {
          NavigateBack() => onBack(),
          OpenMovie(:final movieId, :final heroTag) => onOpenMovie(movieId, heroTag),
        },
      ),
    );
  }
}
