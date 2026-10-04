import 'package:cine_vault/core/result/core_result.dart';
import 'package:cine_vault/core/ui.dart';
import 'package:cine_vault/core/widgets/movie_ui/movie_ui.dart';
import 'package:cine_vault/domain/domain.dart';
import 'package:cine_vault/features/movie_details/bloc/movie_details_bloc.dart';
import 'package:cine_vault/features/movie_details/view/widgets/cast_row.dart';
import 'package:cine_vault/features/movie_details/view/widgets/details_app_bar.dart';
import 'package:cine_vault/features/movie_details/view/widgets/genre_chips.dart';
import 'package:cine_vault/features/movie_details/view/widgets/meta_row.dart';
import 'package:cine_vault/features/movie_details/view/widgets/similar_movies_row.dart';
import 'package:cine_vault/features/movie_details/view/widgets/trailer_player_modal.dart';
import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The details UI. Sends events to [MovieDetailsBloc], shows the trailer
/// dialog, and reports navigation taps through the callbacks.
class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({
    required this.favoriteButton,
    required this.onBack,
    required this.onMovieTap,
    super.key,
    this.heroTag,
  });

  final FavoriteButtonBuilder favoriteButton;
  final VoidCallback onBack;
  final void Function(Movie movie, String heroTag) onMovieTap;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MovieDetailsBloc>();
    return BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, state) => _MovieDetailsBody(
        state: state,
        heroTag: heroTag,
        favoriteButton: favoriteButton,
        onBack: onBack,
        onRetry: () => bloc.add(const MovieDetailsEvent.retried()),
        onMovieTap: onMovieTap,
        onPlayTrailer: (trailer, title) => showAppDialog(
          context: context,
          builder: (_, close) =>
              TrailerPlayerModal(videoKey: trailer.key, title: title, onClose: close),
        ),
      ),
    );
  }
}

/// Draws one [MovieDetailsState].
class _MovieDetailsBody extends StatelessWidget {
  const _MovieDetailsBody({
    required this.state,
    required this.favoriteButton,
    required this.onBack,
    required this.onRetry,
    required this.onMovieTap,
    required this.onPlayTrailer,
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
            retryLabel: AppLocalizations.of(context).tryAgain,
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
    final l10n = AppLocalizations.of(context);
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
                  CastRow(cast: state.cast),
                ],
                if (state.similarMovies.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  SectionTitle(l10n.detailsSimilarMovies),
                  const SizedBox(height: 12),
                  SimilarMoviesRow(
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
