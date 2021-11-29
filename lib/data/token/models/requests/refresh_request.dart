import 'package:json_annotation/json_annotation.dart';

part 'refresh_request.g.dart';

@JsonSerializable()
class RefreshRequest {
  final String? refresh;

  RefreshRequest(this.refresh);

  factory RefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshRequestToJson(this);
}
