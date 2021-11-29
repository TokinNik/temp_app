import 'package:temp_app/data/login/models/network/login_response.dart';
import 'package:temp_app/data/user/mapper/user_mapper.dart';
import 'package:temp_app/domain/models/login_model.dart';

class LoginMapper {
  LoginMapper._();

  static LoginModel call(LoginResponse data) {
    return LoginModel(
      accessToken: data.accessToken,
      user: UserMapper.toDomain(data.user),
    );
  }
}
