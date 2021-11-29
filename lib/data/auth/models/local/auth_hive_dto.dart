import 'package:hive/hive.dart';
import 'package:temp_app/core/hive.dart';

part 'auth_hive_dto.g.dart';

@HiveType(typeId: HiveTypeId.auth)
class AuthHiveDto {
  @HiveField(0)
  String? login;

  @HiveField(1)
  String? password;

  @HiveField(3)
  String? accessToken;

  AuthHiveDto({this.login, this.password, this.accessToken});
}
