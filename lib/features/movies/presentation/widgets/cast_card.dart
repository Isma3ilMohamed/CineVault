import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/cast_member.dart';

/// ببساطة كدا: card صغيرة للـ cast member
/// - صورة دائرية (w185 من TMDB)
/// - الاسم + الشخصية تحت
class CastCard extends StatelessWidget {
  final CastMember member;
  final double width;

  const CastCard({
    super.key,
    required this.member,
    this.width = 96,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: SizedBox(
              width: width,
              height: width,
              child: member.fullProfileUrl != null
                  ? CachedNetworkImage(
                      imageUrl: member.fullProfileUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _buildShimmer(),
                      errorWidget: (_, __, ___) =>
                          _buildPlaceholder(onSurface),
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
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: onSurface,
            ),
          ),
          if (member.character.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              member.character,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: onSurface.withValues(alpha: 0.6),
              ),
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
    return Container(
      color: onSurface.withValues(alpha: 0.1),
      child: Icon(
        Icons.person_rounded,
        color: onSurface.withValues(alpha: 0.3),
        size: width * 0.5,
      ),
    );
  }
}
