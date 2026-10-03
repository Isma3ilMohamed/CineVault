import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:movie_details/src/l10n/generated/movie_details_localizations.dart';

/// Rating, vote count and release year.
class MetaRow extends StatelessWidget {
  const MetaRow({required this.rating, required this.voteCount, required this.year, super.key});

  final String rating;
  final int voteCount;
  final String year;

  @override
  Widget build(BuildContext context) {
    final l10n = MovieDetailsLocalizations.of(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = onSurface.withValues(alpha: 0.7);
    return Row(
      children: [
        Icon(Icons.star_rounded, color: context.appColors.rating, size: 20),
        const SizedBox(width: 4),
        // Flexible: long vote counts (or large text scale) ellipsize instead of overflowing.
        Flexible(
          child: Text(
            '$rating · ${l10n.detailsVotes(voteCount)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: muted),
          ),
        ),
        const SizedBox(width: 16),
        Icon(Icons.calendar_today_rounded, color: onSurface.withValues(alpha: 0.55), size: 16),
        const SizedBox(width: 6),
        Text(year, style: TextStyle(color: muted)),
      ],
    );
  }
}
