import 'package:cine_vault/core/ui.dart';
import 'package:flutter/material.dart';

class CastCard extends StatelessWidget {
  const CastCard({
    required this.name,
    required this.character,
    required this.profileUrl,
    super.key,
    this.width = 96,
  });

  final String name;
  final String character;
  final String? profileUrl;
  final double width;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: width,
      child: Column(
        children: [
          ClipOval(
            child: SizedBox.square(
              dimension: width,
              child: RemoteImage(
                url: profileUrl,
                fallbackIcon: Icons.person_rounded,
                sourceAspectRatio: TmdbImages.profileAspectRatio,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: onSurface),
          ),
          if (character.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              character,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: onSurface.withValues(alpha: 0.6)),
            ),
          ],
        ],
      ),
    );
  }
}
