import 'package:cine_vault/features/favorites/favorites_bloc.dart';
import 'package:cine_vault/features/favorites/favorites_contract.dart';
import 'package:cine_vault/features/favorites/favorites_navigation.dart';
import 'package:cine_vault/features/favorites/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Entry and exit point of the favorites screen.
class FavoritesRoute extends StatelessWidget {
  const FavoritesRoute({required this.onOpenMovie, required this.onOpenSearch, super.key});

  final void Function(int movieId, String heroTag) onOpenMovie;
  final VoidCallback onOpenSearch;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<FavoritesBloc>()..add(const FavoritesEvent.started()),
      child: FavoritesScreen(
        onNavigation: (navigation) => switch (navigation) {
          OpenMovie(:final movieId, :final heroTag) => onOpenMovie(movieId, heroTag),
          OpenSearch() => onOpenSearch(),
        },
      ),
    );
  }
}
