import '../../domain/entities/cast_member.dart';

/// Only `cast` is parsed from the credits response; `crew` is ignored.
class CastMemberModel {
  final int id;
  final String name;
  final String character;
  final String? profilePath;
  final int order;

  const CastMemberModel({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
    required this.order,
  });

  factory CastMemberModel.fromJson(Map<String, dynamic> json) {
    return CastMemberModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      character: json['character'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
      order: json['order'] as int? ?? 999,
    );
  }

  CastMember toEntity() => CastMember(
        id: id,
        name: name,
        character: character,
        profilePath: profilePath,
        order: order,
      );
}

class CreditsResponse {
  final List<CastMemberModel> cast;

  const CreditsResponse({required this.cast});

  factory CreditsResponse.fromJson(Map<String, dynamic> json) {
    return CreditsResponse(
      cast: (json['cast'] as List<dynamic>?)
              ?.map((e) => CastMemberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
