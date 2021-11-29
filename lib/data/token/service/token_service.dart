import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:temp_app/core/network/dio_utils/dio_error_unwrapper.dart';
import 'package:temp_app/data/token/models/responses/refresh_response.dart';

part 'token_service.g.dart';

@RestApi()
abstract class TokenService {
  @POST('refresh/path')
  Future<RefreshResponse> postRefresh(@Body() dynamic body);
}

class TokenServiceImpl with DioErrorUnwrapper implements TokenService {
  _TokenService service;

  TokenServiceImpl(Dio dio) : service = _TokenService(dio);

  @override
  Future<RefreshResponse> postRefresh(body) => run(service.postRefresh(body));
}
