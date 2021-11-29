import 'package:json_annotation/json_annotation.dart';
import 'package:temp_app/data/user/models/network/user_response.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String accessToken;
  final UserResponse user;

  LoginResponse(
    this.accessToken,
    this.user,
  );

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
