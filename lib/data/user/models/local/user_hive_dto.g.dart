// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_hive_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserHiveDtoAdapter extends TypeAdapter<UserHiveDto> {
  @override
  final int typeId = 3;

  @override
  UserHiveDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserHiveDto(
      email: fields[0] as String?,
      firstName: fields[1] as String?,
      lastName: fields[2] as String?,
      middleName: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserHiveDto obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.middleName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserHiveDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
