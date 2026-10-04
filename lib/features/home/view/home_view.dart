import 'package:cine_vault/core/constants/app_info.dart';
import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/core/ui.dart';
import 'package:cine_vault/core/widgets/movie_ui/movie_ui.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/home/bloc/home_bloc.dart';
import 'package:cine_vault/features/home/view/widgets/featured_carousel.dart';
import 'package:cine_vault/features/home/view/widgets/movie_section.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The home screen UI for every [HomeState]. Sends events to [HomeBloc] and
/// reports taps through the callbacks, so it never navigates by itself.
class HomeView extends StatelessWidget {
  const HomeView({
    required this.favoriteButton,
    required this.onMovieTap,
    required this.onSeeAll,
    required this.onSearch,
    super.key,
  });

  final FavoriteButtonBuilder favoriteButton;
  final void Function(Movie movie, String heroTag) onMovieTap;
  final ValueChanged<MovieCategory> onSeeAll;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => _refreshFailure(current) != _refreshFailure(previous),
      listener: (context, state) {
        final failure = _refreshFailure(state);
        if (failure == null) return;
        final message = AppLocalizations.of(context)
            .homeRefreshFailed(failure.localizedMessage(context));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) => Scaffold(
        body: switch (state) {
          HomeInitial() ||
          HomeLoading() => Center(child: CircularProgressIndicator(color: context.appColors.brand)),
          HomeError(:final failure) => ErrorView(
            message: failure.localizedMessage(context),
            retryLabel: AppLocalizations.of(context).tryAgain,
            onRetry: () => bloc.add(const HomeEvent.retried()),
          ),
          HomeLoaded(:final sections) => _LoadedBody(
            sections: sections,
            favoriteButton: favoriteButton,
            onRefresh: () async {
              bloc.add(const HomeEvent.refreshed());
              // Keep the pull-to-refresh spinner until the refresh is done.
              await bloc.stream.firstWhere((s) => s is! HomeLoaded || !s.isRefreshing);
            },
            onMovieTap: onMovieTap,
            onSeeAll: onSeeAll,
            onSearch: onSearch,
          ),
        },
      ),
    );
  }

  static Failure? _refreshFailure(HomeState state) =>
      state is HomeLoaded ? state.refreshFailure : null;
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({
    required this.sections,
    required this.favoriteButton,
    required this.onRefresh,
    required this.onMovieTap,
    required this.onSeeAll,
    required this.onSearch,
  });

  final Map<MovieCategory, List<Movie>> sections;
  final FavoriteButtonBuilder favoriteButton;
  final Future<void> Function() onRefresh;
  final void Function(Movie movie, String heroTag) onMovieTap;
  final ValueChanged<MovieCategory> onSeeAll;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final brand = context.appColors.brand;
    return RefreshIndicator(
      color: brand,
      onRefresh: onRefresh,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text(
              AppInfo.name,
              style: TextStyle(fontWeight: FontWeight.bold, color: brand, letterSpacing: 1.2),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: AppLocalizations.of(context).homeSearch,
                onPressed: onSearch,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: FeaturedCarousel(
              movies: sections[MovieCategory.popular] ?? const [],
              onMovieTap: onMovieTap,
            ),
          ),
          // Rows in enum order; each one has its own Hero tag prefix.
          for (final category in MovieCategory.values)
            SliverPadding(
              padding: const EdgeInsets.only(top: 24),
              sliver: SliverToBoxAdapter(
                child: MovieSection(
                  title: category.label(context),
                  movies: sections[category] ?? const [],
                  heroTagPrefix: category.name,
                  favoriteButton: favoriteButton,
                  onMovieTap: onMovieTap,
                  onSeeAll: () => onSeeAll(category),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
