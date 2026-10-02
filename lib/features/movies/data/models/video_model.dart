import '../../domain/entities/video.dart';

class VideoModel {
  final String id;
  final String key;
  final String site;
  final String name;
  final String type;
  final bool official;

  const VideoModel({
    required this.id,
    required this.key,
    required this.site,
    required this.name,
    required this.type,
    required this.official,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String? ?? '',
      key: json['key'] as String? ?? '',
      site: json['site'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      official: json['official'] as bool? ?? false,
    );
  }

  Video toEntity() => Video(
        id: id,
        key: key,
        site: site,
        name: name,
        type: type,
        official: official,
      );
}

class VideosResponse {
  final List<VideoModel> results;

  const VideosResponse({required this.results});

  factory VideosResponse.fromJson(Map<String, dynamic> json) {
    return VideosResponse(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
