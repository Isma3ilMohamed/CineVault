import 'dart:async';

import 'package:cine_vault/app/di.dart';
import 'package:cine_vault/features/favorites/view/favorite_button.dart';
import 'package:cine_vault/features/search/bloc/search_bloc.dart';
import 'package:cine_vault/features/search/view/search_view.dart';
import 'package:cine_vault/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Search entry: provides the bloc, loads the recent searches once, and wires
/// the view's taps to navigation.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchBloc>()..add(const SearchEvent.started()),
      child: SearchView(
        favoriteButton: (_, movie, size) => FavoriteButton(movie: movie, size: size),
        onBack: context.pop,
        onMovieTap: (movie, heroTag) =>
            unawaited(context.push(AppRoutes.movieDetailsOf(movie.id, heroTag: heroTag))),
      ),
    );
  }
}
