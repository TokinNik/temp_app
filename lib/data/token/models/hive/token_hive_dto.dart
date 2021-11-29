import 'package:hive/hive.dart';

import '../../../../core/hive.dart';

part 'token_hive_dto.g.dart';

@HiveType(typeId: HiveTypeId.token)
class TokenHiveDto {
  @HiveField(0)
  String? value;

  @HiveField(1)
  DateTime? expiresIn;

  TokenHiveDto({
    this.value,
    this.expiresIn,
  });
}
