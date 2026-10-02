import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

class RecentSearchesList extends StatelessWidget {
  final List<String> searches;
  final ValueChanged<String> onTap;
  final VoidCallback onClearAll;

  const RecentSearchesList({
    super.key,
    required this.searches,
    required this.onTap,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) {
      return const _EmptyRecents();
    }

    final l10n = AppLocalizations.of(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
          child: Row(
            children: [
              Text(
                l10n.searchRecent,
                style: TextStyle(
                  color: onSurface.withValues(alpha: 0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onClearAll,
                child: Text(
                  l10n.clear,
                  style: const TextStyle(
                    color: Color(0xFFE50914),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searches.length,
            itemBuilder: (context, i) {
              final query = searches[i];
              return ListTile(
                leading: Icon(
                  Icons.history_rounded,
                  color: onSurface.withValues(alpha: 0.55),
                ),
                title: Text(query),
                trailing: Icon(
                  Icons.north_west_rounded,
                  color: onSurface.withValues(alpha: 0.4),
                  size: 18,
                ),
                onTap: () => onTap(query),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyRecents extends StatelessWidget {
  const _EmptyRecents();

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.movie_filter_outlined,
              size: 72,
              color: onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).searchEmptyPrompt,
              style: TextStyle(
                color: onSurface.withValues(alpha: 0.55),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
