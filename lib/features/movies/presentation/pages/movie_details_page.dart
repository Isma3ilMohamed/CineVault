import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../favorites/presentation/widgets/favorite_heart_button.dart';
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/video.dart';
import '../bloc/movie_details_bloc.dart';
import '../cubit/genres_cubit.dart';
import '../widgets/cast_card.dart';
import '../widgets/movie_card.dart';
import '../widgets/trailer_player_modal.dart';

/// The bloc and its initial load event are created in the router; creating
/// them in build would refetch on every rebuild.
class MovieDetailsPage extends StatelessWidget {
  final int movieId;

  /// Hero tag used by the source screen; null when opened via deep link.
  final String? heroTag;

  const MovieDetailsPage({
    super.key,
    required this.movieId,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          return switch (state) {
            MovieDetailsInitial() || MovieDetailsLoading() =>
              const _LoadingView(),
            MovieDetailsError(:final message) =>
              _ErrorView(message: message, movieId: movieId),
            MovieDetailsLoaded(
              :final movie,
              :final similarMovies,
              :final cast,
              :final trailer,
            ) =>
              _LoadedView(
                movie: movie,
                similarMovies: similarMovies,
                cast: cast,
                trailer: trailer,
                heroTag: heroTag,
              ),
          };
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFFE50914)),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final int movieId;

  const _ErrorView({required this.message, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 8,
            child: _BackButton(onPressed: () => context.pop()),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: onSurface.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context
                        .read<MovieDetailsBloc>()
                        .add(RetryMovieDetails(movieId)),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.tryAgain),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final Movie movie;
  final List<Movie> similarMovies;
  final List<CastMember> cast;
  final Video? trailer;
  final String? heroTag;

  const _LoadedView({
    required this.movie,
    required this.similarMovies,
    required this.cast,
    this.trailer,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return CustomScrollView(
      slivers: [
        _DetailsAppBar(movie: movie, heroTag: heroTag),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                _MetaRow(movie: movie),
                const SizedBox(height: 12),
                _GenreChips(genreIds: movie.genreIds),
                if (trailer != null) ...[
                  const SizedBox(height: 16),
                  _PlayTrailerButton(trailer: trailer!, title: movie.title),
                ],
                const SizedBox(height: 24),
                _SectionTitle(l10n.detailsOverview),
                const SizedBox(height: 8),
                Text(
                  movie.overview.isEmpty
                      ? l10n.detailsOverviewNone
                      : movie.overview,
                  style: TextStyle(
                    color: onSurface.withValues(alpha: 0.75),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                if (cast.isNotEmpty) ...[
                  _SectionTitle(l10n.detailsCast),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 170,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: cast.length > 15 ? 15 : cast.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => CastCard(member: cast[i]),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                if (similarMovies.isNotEmpty) ...[
                  _SectionTitle(l10n.detailsSimilarMovies),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 290,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: similarMovies.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final similar = similarMovies[i];
                        // Distinct prefix so tags do not collide with Hero tags on the pushed route.
                        final tag = 'similar_${similar.id}';
                        return MovieCard(
                          movie: similar,
                          heroTag: tag,
                          onTap: () => context.push(
                            '/movie/${similar.id}',
                            extra: {'heroTag': tag},
                          ),
                        );
                      },
                    ),
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

class _DetailsAppBar extends StatelessWidget {
  final Movie movie;
  final String? heroTag;

  const _DetailsAppBar({required this.movie, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final Widget background = Stack(
      fit: StackFit.expand,
      children: [
        if (movie.fullBackdropUrl != null)
          CachedNetworkImage(
            imageUrl: movie.fullBackdropUrl!,
            fit: BoxFit.cover,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Container(color: Colors.grey[800]),
            ),
            errorWidget: (_, __, ___) => Container(color: Colors.grey[900]),
          )
        else
          Container(color: Colors.grey[900]),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.4),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.95),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),
      ],
    );

    final Widget heroBackground =
        heroTag == null ? background : Hero(tag: heroTag!, child: background);

    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: Colors.black,
      leading: _BackButton(onPressed: () => context.pop()),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8, top: 4),
          child: FavoriteHeartButton(movie: movie, size: 24),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(background: heroBackground),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Movie movie;

  const _MetaRow({required this.movie});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = onSurface.withValues(alpha: 0.7);
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 20),
        const SizedBox(width: 4),
        Text(
          '${movie.formattedRating} · ${l10n.detailsVotes(movie.voteCount)}',
          style: TextStyle(color: muted),
        ),
        const SizedBox(width: 16),
        Icon(
          Icons.calendar_today_rounded,
          color: onSurface.withValues(alpha: 0.55),
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          movie.releaseYear,
          style: TextStyle(color: muted),
        ),
      ],
    );
  }
}

class _PlayTrailerButton extends StatelessWidget {
  final Video trailer;
  final String title;

  const _PlayTrailerButton({required this.trailer, required this.title});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ElevatedButton.icon(
      onPressed: () => showDialog<void>(
        context: context,
        barrierColor: Colors.black87,
        builder: (_) => TrailerPlayerModal(
          videoKey: trailer.key,
          title: title,
        ),
      ),
      icon: const Icon(Icons.play_arrow_rounded),
      label: Text(l10n.playTrailer),
    );
  }
}

/// Hidden when genres failed to load (empty GenresCubit map).
class _GenreChips extends StatelessWidget {
  final List<int> genreIds;

  const _GenreChips({required this.genreIds});

  @override
  Widget build(BuildContext context) {
    final names = context.select<GenresCubit, List<String>>(
      (c) => c.namesFor(genreIds),
    );
    if (names.isEmpty) return const SizedBox.shrink();

    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final name in names)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: onSurface.withValues(alpha: 0.1),
              border: Border.all(
                color: onSurface.withValues(alpha: 0.25),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              name,
              style: TextStyle(
                color: onSurface.withValues(alpha: 0.85),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
