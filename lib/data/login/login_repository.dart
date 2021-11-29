
import 'package:temp_app/data/login/mapper/login_mapper.dart';
import 'package:temp_app/data/login/service/login_service.dart';
import 'package:temp_app/data/user/models/network/user_response.dart';
import 'package:temp_app/domain/models/login_model.dart';

import 'models/network/login_request.dart';
import 'models/network/login_response.dart';

abstract class LoginRepository {
  Future<LoginModel> login(LoginRequest body);
}

class LoginRepositoryImpl extends LoginRepository {
  final LoginService _loginService;

  LoginRepositoryImpl(this._loginService);

  @override
  Future<LoginModel> login(LoginRequest body) async {
    // final result = await _loginService.postLogin(body);//todo uncomment
    final result = LoginResponse(//todo delete
      "accessToken",
      UserResponse(
        "email",
        "firstName",
        "lastName",
        "middleName",
      )
    );
    await Future.delayed(Duration(seconds: 1));
    return LoginMapper.call(result);
  }
}
