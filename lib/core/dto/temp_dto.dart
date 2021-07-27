import 'package:json_annotation/json_annotation.dart';

part 'temp_dto.g.dart';

@JsonSerializable()
class TempDto {
  @JsonKey(
    name: "string_var",
    required: true,
  )
  final String stringVar;
  @JsonKey(name: "int_var")
  final int intVar;
  @JsonKey(name: "bool_var")
  final bool boolVar;
  final List<String> list;

  TempDto({
    this.stringVar,
    this.intVar,
    this.boolVar,
    this.list,
  });

  factory TempDto.fromJson(Map<String, dynamic> json) =>
      _$TempDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TempDtoToJson(this);
}
