import 'package:flutter/material.dart';

class GenreChips extends StatelessWidget {
  const GenreChips({required this.genres, super.key});

  final List<String> genres;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final name in genres)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: onSurface.withValues(alpha: 0.1),
              border: Border.all(color: onSurface.withValues(alpha: 0.25)),
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
