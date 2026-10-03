import 'package:cine_vault/core/widgets/movie_ui/movie_ui.dart';
import 'package:cine_vault/features/home/home_bloc.dart';
import 'package:cine_vault/features/home/home_content.dart';
import 'package:cine_vault/features/home/home_contract.dart';
import 'package:cine_vault/features/home/home_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Binds the bloc to [HomeContent].
class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.favoriteButton, required this.onNavigation, super.key});

  final FavoriteButtonBuilder favoriteButton;
  final ValueChanged<HomeNavigation> onNavigation;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => HomeContent(
        state: state,
        favoriteButton: favoriteButton,
        onRetry: () => bloc.add(const HomeEvent.retried()),
        onRefresh: () async {
          bloc.add(const HomeEvent.refreshed());
          // Keep the pull-to-refresh spinner until the refresh is done.
          await bloc.stream.firstWhere((state) => state is! HomeLoaded || !state.isRefreshing);
        },
        onMovieTap: (movie, heroTag) =>
            onNavigation(OpenMovie(movieId: movie.id, heroTag: heroTag)),
        onSeeAll: (category) => onNavigation(OpenCategory(category)),
        onSearch: () => onNavigation(const OpenSearch()),
      ),
    );
  }
}
