import 'package:core_result/core_result.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:movie_details/src/l10n/generated/movie_details_localizations.dart';
import 'package:movie_details/src/movie_details_contract.dart';
import 'package:movie_details/src/widgets/cast_card.dart';
import 'package:movie_details/src/widgets/details_app_bar.dart';
import 'package:movie_details/src/widgets/genre_chips.dart';
import 'package:movie_details/src/widgets/meta_row.dart';
import 'package:movie_ui/movie_ui.dart';

/// Pure UI for every [MovieDetailsState]. No bloc, no navigation: state and
/// callbacks in.
class MovieDetailsContent extends StatelessWidget {
  const MovieDetailsContent({
    required this.state,
    required this.favoriteButton,
    required this.onBack,
    required this.onRetry,
    required this.onMovieTap,
    required this.onPlayTrailer,
    super.key,
    this.heroTag,
  });

  final MovieDetailsState state;
  final FavoriteButtonBuilder favoriteButton;
  final VoidCallback onBack;
  final VoidCallback onRetry;
  final void Function(Movie movie, String heroTag) onMovieTap;
  final void Function(Video trailer, String title) onPlayTrailer;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (state) {
        MovieDetailsInitial() || MovieDetailsLoading() => Center(
          child: CircularProgressIndicator(color: context.appColors.brand),
        ),
        MovieDetailsError(:final failure) => _ErrorBody(
          failure: failure,
          onBack: onBack,
          onRetry: onRetry,
        ),
        final MovieDetailsLoaded loaded => _LoadedBody(
          state: loaded,
          heroTag: heroTag,
          favoriteButton: favoriteButton,
          onBack: onBack,
          onMovieTap: onMovieTap,
          onPlayTrailer: onPlayTrailer,
        ),
      },
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.failure, required this.onBack, required this.onRetry});

  final Failure failure;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ErrorView(
            message: failure.localizedMessage(context),
            retryLabel: CoreUiLocalizations.of(context).tryAgain,
            onRetry: onRetry,
          ),
          PositionedDirectional(top: 8, start: 8, child: CircleBackButton(onPressed: onBack)),
        ],
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({
    required this.state,
    required this.favoriteButton,
    required this.onBack,
    required this.onMovieTap,
    required this.onPlayTrailer,
    this.heroTag,
  });

  final MovieDetailsLoaded state;
  final FavoriteButtonBuilder favoriteButton;
  final VoidCallback onBack;
  final void Function(Movie movie, String heroTag) onMovieTap;
  final void Function(Video trailer, String title) onPlayTrailer;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final l10n = MovieDetailsLocalizations.of(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final movie = state.movie;
    final trailer = state.trailer;

    return CustomScrollView(
      slivers: [
        DetailsAppBar(
          backdropUrl: TmdbImages.backdrop(movie.backdropPath),
          heroTag: heroTag,
          onBack: onBack,
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8, top: 4),
              child: favoriteButton(context, movie, 24),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: onSurface),
                ),
                const SizedBox(height: 8),
                MetaRow(
                  rating: MovieFormat.rating(movie.voteAverage),
                  voteCount: movie.voteCount,
                  year: MovieFormat.year(movie.releaseDate),
                ),
                if (state.genres.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  GenreChips(genres: state.genres),
                ],
                if (trailer != null) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => onPlayTrailer(trailer, movie.title),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(l10n.playTrailer),
                  ),
                ],
                const SizedBox(height: 24),
                SectionTitle(l10n.detailsOverview),
                const SizedBox(height: 8),
                Text(
                  movie.overview.isEmpty ? l10n.detailsOverviewNone : movie.overview,
                  style: TextStyle(
                    color: onSurface.withValues(alpha: 0.75),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                if (state.cast.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  SectionTitle(l10n.detailsCast),
                  const SizedBox(height: 12),
                  _CastRow(cast: state.cast),
                ],
                if (state.similarMovies.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  SectionTitle(l10n.detailsSimilarMovies),
                  const SizedBox(height: 12),
                  _SimilarMoviesRow(
                    movies: state.similarMovies,
                    favoriteButton: favoriteButton,
                    onMovieTap: onMovieTap,
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CastRow extends StatelessWidget {
  const _CastRow({required this.cast});

  static const _maxShown = 15;

  final List<CastMember> cast;

  @override
  Widget build(BuildContext context) {
    final shown = cast.take(_maxShown).toList();
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: shown.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => CastCard(
          name: shown[i].name,
          character: shown[i].character,
          profileUrl: TmdbImages.profile(shown[i].profilePath),
        ),
      ),
    );
  }
}

class _SimilarMoviesRow extends StatelessWidget {
  const _SimilarMoviesRow({
    required this.movies,
    required this.favoriteButton,
    required this.onMovieTap,
  });

  final List<Movie> movies;
  final FavoriteButtonBuilder favoriteButton;
  final void Function(Movie movie, String heroTag) onMovieTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final movie = movies[i];
          // Distinct prefix so tags do not collide with Hero tags on the pushed route.
          final tag = 'similar_${movie.id}';
          return MovieCard(
            movie: movie,
            favoriteButton: favoriteButton,
            heroTag: tag,
            onTap: () => onMovieTap(movie, tag),
          );
        },
      ),
    );
  }
}
