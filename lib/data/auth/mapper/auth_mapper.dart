
import 'package:temp_app/data/auth/models/auth.dart';
import 'package:temp_app/data/auth/models/local/auth_hive_dto.dart';

class AuthMapper {
  AuthMapper._();

  static Auth toDomain(AuthHiveDto? authHiveDto) {
    return Auth(
      accessToken: authHiveDto?.accessToken,
      password: authHiveDto?.password,
      login: authHiveDto?.login,
    );
  }

  static AuthHiveDto toDto(Auth? authHiveDto) {
    return AuthHiveDto(
      accessToken: authHiveDto?.accessToken,
      password: authHiveDto?.password,
      login: authHiveDto?.login,
    );
  }
}
