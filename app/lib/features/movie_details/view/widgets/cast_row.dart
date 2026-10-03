import 'package:cine_vault/features/movie_details/view/widgets/cast_card.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

/// Horizontal row of the first cast members.
class CastRow extends StatelessWidget {
  const CastRow({required this.cast, super.key});

  static const _maxShown = 15;

  final List<CastMember> cast;

  @override
  Widget build(BuildContext context) {
    final shown = cast.take(_maxShown).toList();
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: shown.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => CastCard(
          name: shown[i].name,
          character: shown[i].character,
          profileUrl: TmdbImages.profile(shown[i].profilePath),
        ),
      ),
    );
  }
}
