import 'package:core_base/widgets.dart';
import 'package:core_result/core_result.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:home/src/home_bloc.dart';
import 'package:home/src/home_contract.dart';
import 'package:home/src/home_navigation.dart';
import 'package:home/src/home_screen.dart';
import 'package:home/src/l10n/generated/home_localizations.dart';
import 'package:movie_ui/movie_ui.dart';

/// Entry and exit point of the home screen.
///
/// Also the only place that reacts to [HomeEffect]s.
class HomeRoute extends StatelessWidget {
  const HomeRoute({
    required this.onOpenMovie,
    required this.onOpenCategory,
    required this.onOpenSearch,
    required this.favoriteButton,
    super.key,
  });

  final void Function(int movieId, String heroTag) onOpenMovie;
  final ValueChanged<MovieCategory> onOpenCategory;
  final VoidCallback onOpenSearch;
  final FavoriteButtonBuilder favoriteButton;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<HomeBloc>()..add(const HomeEvent.started()),
      child: BlocEffectListener<HomeBloc, HomeEffect>(
        onEffect: (context, effect) => switch (effect) {
          HomeRefreshFailed(:final failure) => _showRefreshFailed(context, failure),
        },
        child: HomeScreen(
          favoriteButton: favoriteButton,
          onNavigation: (navigation) => switch (navigation) {
            OpenMovie(:final movieId, :final heroTag) => onOpenMovie(movieId, heroTag),
            OpenCategory(:final category) => onOpenCategory(category),
            OpenSearch() => onOpenSearch(),
          },
        ),
      ),
    );
  }

  void _showRefreshFailed(BuildContext context, Failure failure) {
    final message = HomeLocalizations.of(context)
        .homeRefreshFailed(failure.localizedMessage(context));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
