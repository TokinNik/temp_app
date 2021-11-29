import 'package:hive/hive.dart';

import '../../../../core/hive.dart';

part 'user_hive_dto.g.dart';

@HiveType(typeId: HiveTypeId.user)
class UserHiveDto {
  @HiveField(0)
  final String? email;
  @HiveField(1)
  final String? firstName;
  @HiveField(2)
  final String? lastName;
  @HiveField(3)
  final String? middleName;


  UserHiveDto({
    this.email,
    this.firstName,
    this.lastName,
    this.middleName,
  });
}
