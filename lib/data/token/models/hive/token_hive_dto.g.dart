// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_hive_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TokenHiveDtoAdapter extends TypeAdapter<TokenHiveDto> {
  @override
  final int typeId = 1;

  @override
  TokenHiveDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TokenHiveDto(
      value: fields[0] as String?,
      expiresIn: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TokenHiveDto obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.expiresIn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenHiveDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
