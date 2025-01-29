import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
    bool error;
    String message;
    LoginResult loginResult;

    LoginResponse({
        required this.error,
        required this.message,
        required this.loginResult,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

    Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginResult {
    String userId;
    String name;
    String token;

    LoginResult({
        required this.userId,
        required this.name,
        required this.token,
    });

    factory LoginResult.fromJson(Map<String, dynamic> json) => _$LoginResultFromJson(json);

    Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}
