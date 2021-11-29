import 'package:dio/dio.dart';
import 'package:temp_app/data/token/models/exeptions.dart';
import 'package:temp_app/data/token/token_holder.dart';import 'package:temp_app/core/network/dio_utils/dio_extensions.dart';


class TokenInterceptor extends Interceptor {
  final TokenHolder _tokenHolder;
  final Lock requestLock;

  TokenInterceptor(this._tokenHolder, this.requestLock);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final authToken = _tokenHolder.authToken;

    if (authToken == null) {
      return handler.reject(_buildSessionExpiredException(options));
    }

    var authTokenValue = authToken.value;

    if (authToken.isNearExpiration()) {
      requestLock.lock();

      try {
        final newToken = await _tokenHolder.tryRefreshToken();

        if (newToken == null) {
          requestLock.clear();
          requestLock.unlock();
          return handler.reject(_buildSessionExpiredException(options));
        } else {
          authTokenValue = newToken;
        }
      } catch (error) {
        requestLock.clear(error.toString());
        requestLock.unlock();
        return handler.reject(DioError(requestOptions: options, error: error));
      }

      requestLock.unlock();
    }

    options.headers['Authorization'] = 'Bearer $authTokenValue';
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.type == DioErrorType.response &&
        err.response!.isUnauthorizedError) {
      //Tokens are blocked so refresh are useless
      _tokenHolder.onAuthExpired();
      return handler.next(_buildSessionExpiredException(err.requestOptions));
    }

    super.onError(err, handler);
  }

  DioError _buildSessionExpiredException(RequestOptions options) {
    return DioError(requestOptions: options, error: SessionExpiredException());
  }
}
