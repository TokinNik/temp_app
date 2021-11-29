import 'package:json_annotation/json_annotation.dart';

part 'refresh_response.g.dart';

@JsonSerializable()
class RefreshResponse {
  @JsonKey(name: 'access')
  final String? accessToken;

  @JsonKey(name: 'refresh')
  final String? refreshToken;

  RefreshResponse(
    this.accessToken,
    this.refreshToken,
  );

  factory RefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshResponseToJson(this);
}
