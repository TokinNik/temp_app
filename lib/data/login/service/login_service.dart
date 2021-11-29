import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:temp_app/core/network/dio_utils/dio_error_unwrapper.dart';
import 'package:temp_app/data/login/models/network/login_request.dart';
import 'package:temp_app/data/login/models/network/login_response.dart';

part 'login_service.g.dart';

@RestApi()
abstract class LoginService {
  @POST('login/token')
  Future<LoginResponse> postLogin(@Body() LoginRequest body);
}

class LoginServiceImpl with DioErrorUnwrapper implements LoginService {
  _LoginService service;

  LoginServiceImpl(Dio dio) : service = _LoginService(dio);

  @override
  Future<LoginResponse> postLogin(body) => run(service.postLogin(body));
}
