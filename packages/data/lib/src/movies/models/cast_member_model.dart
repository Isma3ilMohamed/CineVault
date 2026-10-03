import 'package:domain/domain.dart';

/// Only `cast` is parsed from the credits response; `crew` is ignored.
class CastMemberModel {
  const CastMemberModel({
    required this.id,
    required this.name,
    required this.character,
    required this.order,
    this.profilePath,
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
  final int id;
  final String name;
  final String character;
  final String? profilePath;
  final int order;

  CastMember toEntity() =>
      CastMember(id: id, name: name, character: character, profilePath: profilePath, order: order);
}

class CreditsResponse {
  const CreditsResponse({required this.cast});

  factory CreditsResponse.fromJson(Map<String, dynamic> json) {
    return CreditsResponse(
      cast:
          (json['cast'] as List<dynamic>?)
              ?.map((e) => CastMemberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
  final List<CastMemberModel> cast;
}
