import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse {
  final String email;
  final String? firstName;
  final String? lastName;
  final String? middleName;

  UserResponse(
      this.email,
      this.firstName,
      this.lastName,
      this.middleName,
      );

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}