import 'package:json_annotation/json_annotation.dart';

part 'post_response.g.dart';

@JsonSerializable()
class PostResponse {
    bool error;
    String message;

    PostResponse({
        required this.error,
        required this.message,
    });

    factory PostResponse.fromJson(Map<String, dynamic> json) => _$PostResponseFromJson(json);

    Map<String, dynamic> toJson() => _$PostResponseToJson(this);
}
