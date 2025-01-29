import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class StoryResult {
  bool error;
  String message;
  List<Story> listStory;

  StoryResult({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoryResult.fromJson(Map<String, dynamic> json) => _$StoryResultFromJson(json);

  Map<String, dynamic> toJson() => _$StoryResultToJson(this);
}

@JsonSerializable()
class Story {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double? lat;
  double? lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
