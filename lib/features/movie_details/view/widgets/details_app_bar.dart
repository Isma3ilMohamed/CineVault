import 'package:cine_vault/core/ui.dart';
import 'package:flutter/material.dart';

/// Collapsing app bar with the backdrop. [actions] is where the favorite slot goes.
class DetailsAppBar extends StatelessWidget {
  const DetailsAppBar({
    required this.backdropUrl,
    required this.onBack,
    super.key,
    this.heroTag,
    this.actions = const [],
  });

  final String? backdropUrl;
  final VoidCallback onBack;

  /// Matches the source screen's poster Hero; null when opened via deep link.
  final String? heroTag;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final Widget background = Stack(
      fit: StackFit.expand,
      children: [
        RemoteImage(url: backdropUrl, sourceAspectRatio: TmdbImages.backdropAspectRatio),
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

    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: Colors.black,
      leading: CircleBackButton(onPressed: onBack),
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        background: heroTag == null ? background : Hero(tag: heroTag!, child: background),
      ),
    );
  }
}
