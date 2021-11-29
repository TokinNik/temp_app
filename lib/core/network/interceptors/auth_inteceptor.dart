import 'package:dio/dio.dart';
import 'package:temp_app/data/auth/auth_holder.dart';
import 'package:temp_app/core/network/dio_utils/dio_extensions.dart';
import 'package:temp_app/data/token/models/exeptions.dart';

class AuthInterceptor extends Interceptor {
  final AuthHolder _authHolder;
  final Lock requestLock;
  final Dio dio;

  AuthInterceptor(this._authHolder, this.requestLock, this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final authToken = _authHolder.auth?.accessToken;

    if (authToken == null) {
      return handler.reject(_buildSessionExpiredException(options));
    }
    var authTokenValue = authToken;
    options.headers['Authorization'] = 'Bearer $authTokenValue';
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError error, ErrorInterceptorHandler handler) {
    final authToken = _authHolder.auth?.accessToken;

    if (error.response?.isUnauthorizedError == true) {
      var options = error.response!.requestOptions;
      // If the token has been updated, repeat directly.
      if (authToken != options.headers['Authorization']) {
        options.headers['Authorization'] = 'Bearer $authToken';
        //repeat
        dio.fetch(options).then(
          (r) => handler.resolve(r),
          onError: (e) {
            handler.reject(e);
          },
        );
        return;
      }
      // update token and repeat
      // Lock to block the incoming request until the token updated
      dio.lock();
      dio.interceptors.responseLock.lock();
      dio.interceptors.errorLock.lock();
      _authHolder.tryRefreshToken().then((token) {
        //update token
        options.headers['Authorization'] = 'Bearer $token';
      }).whenComplete(() {
        dio.unlock();
        dio.interceptors.responseLock.unlock();
        dio.interceptors.errorLock.unlock();
      }).then((e) {
        //repeat
        dio.fetch(options).then(
          (r) => handler.resolve(r),
          onError: (e) {
            handler.reject(e);
          },
        );
      });
      return;
    }
    return handler.next(error);
  }

  DioError _buildSessionExpiredException(RequestOptions options) {
    return DioError(requestOptions: options, error: SessionExpiredException());
  }
}
