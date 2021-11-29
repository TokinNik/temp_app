
import 'package:temp_app/core/network/exceptions.dart';
import 'package:temp_app/data/auth/models/auth.dart';
import 'package:temp_app/data/login/models/network/login_request.dart';
import 'package:temp_app/data/login/service/login_service.dart';
import 'package:temp_app/data/token/models/exeptions.dart';

class AuthHolder {
  final LoginService _loginService;

  AuthHolder(this._loginService);

  Auth? auth;

  void init(Auth? auth) {
    this.auth = auth;
  }

  void dispose() {
    auth = null;
  }

  Future<String?> tryRefreshToken() async {
    try {
      final response = await _loginService
          .postLogin(LoginRequest(auth?.login, auth?.password));
      return response.accessToken;
    } catch (error) {
      if (error is UnauthorizedClientApiException) {
        throw SessionExpiredException();
      } else {
        rethrow;
      }
    }
  }
}
