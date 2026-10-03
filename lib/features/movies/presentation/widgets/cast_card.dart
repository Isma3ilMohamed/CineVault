import 'package:cached_network_image/cached_network_image.dart';
import 'package:cine_vault/core/extensions/tmdb_display.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CastCard extends StatelessWidget {
  const CastCard({required this.member, super.key, this.width = 96});
  final CastMember member;
  final double width;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return SizedBox(
      width: width,
      child: Column(
        children: [
          ClipOval(
            child: SizedBox(
              width: width,
              height: width,
              child: member.fullProfileUrl != null
                  ? CachedNetworkImage(
                      imageUrl: member.fullProfileUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => _buildShimmer(),
                      errorWidget: (_, _, _) => _buildPlaceholder(onSurface),
                    )
                  : _buildPlaceholder(onSurface),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: onSurface),
          ),
          if (member.character.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              member.character,
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

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(color: Colors.grey[800]),
    );
  }

  Widget _buildPlaceholder(Color onSurface) {
    return ColoredBox(
      color: onSurface.withValues(alpha: 0.1),
      child: Icon(Icons.person_rounded, color: onSurface.withValues(alpha: 0.3), size: width * 0.5),
    );
  }
}
