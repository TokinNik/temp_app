import 'package:temp_app/data/login/login_repository.dart';
import 'package:temp_app/data/login/models/network/login_request.dart';
import 'package:temp_app/domain/models/login_model.dart';

import '../use_case.dart';

class LoginUseCase implements UseCase<LoginModel, LoginRequest> {
  LoginUseCase(this._loginRepository);

  final LoginRepository _loginRepository;

  @override
  Future<LoginModel> call(LoginRequest body) async {
    final result = await _loginRepository.login(body);
    return result;
  }
}
