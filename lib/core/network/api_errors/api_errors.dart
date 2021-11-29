import 'package:json_annotation/json_annotation.dart';

part 'api_errors.g.dart';

@JsonSerializable()
class ApiError implements Exception {
  final String? code;
  final String? message;

  ApiError(this.code, this.message);

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

  @override
  String toString() {
    return 'ApiError{code: $code, message: $message}';
  }
}
