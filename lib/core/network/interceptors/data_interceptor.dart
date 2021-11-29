import 'dart:io';

import 'package:dio/dio.dart';
import 'package:temp_app/core/network/api_errors/api_errors.dart';
import 'package:temp_app/core/network/dio_utils/dio_extensions.dart';

import '../exceptions.dart';

class DataInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final exception = _parseError(err);
    if (exception != null) {
      err.error = exception;
    }

    super.onError(err, handler);
  }

  Exception? _parseError(DioError err) {
    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
        err.error = ServerConnectionException();
        break;

      case DioErrorType.receiveTimeout:
        err.error = ServerTimeoutException();
        break;

      case DioErrorType.response:
        final response = err.response!;

        if (response.isClientError) {
          if (response.isBadRequestError) {
            try {
              return ApiError.fromJson(response.data);
            } catch (e) {
              return BadRequestClientApiException(response.statusCode,
                  data: response.data);
            }
          }

          if (response.isUnauthorizedError) {
            return UnauthorizedClientApiException(
                httpCode: response.statusCode);
          }

          if (response.isNotFoundError) {
            return NotFoundClientApiException(response.statusCode);
          }

          return ClientApiException(response.statusCode,
              message: response.data.toString());
        }

        if (response.isServerError) {
          return ServerApiException(response.statusCode);
        }

        return UnknownApiException(response.statusCode);

      case DioErrorType.cancel:
        break;

      case DioErrorType.other:
        if (err.error is SocketException) {
          return ServerConnectionException();
        }

        if (err.error is String) {
          //* Happens when Dio's Lock cancels request
          return RequestCancelledException(message: err.error);
        }
        break;
    }

    return null;
  }
}
