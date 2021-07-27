// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temp_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TempDto _$TempDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['string_var']);
  return TempDto(
    stringVar: json['string_var'] as String,
    intVar: json['int_var'] as int,
    boolVar: json['bool_var'] as bool,
    list: (json['list'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$TempDtoToJson(TempDto instance) => <String, dynamic>{
      'string_var': instance.stringVar,
      'int_var': instance.intVar,
      'bool_var': instance.boolVar,
      'list': instance.list,
    };
