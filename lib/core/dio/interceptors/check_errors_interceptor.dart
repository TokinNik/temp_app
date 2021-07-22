import 'package:dio/dio.dart';

class CheckErrorsInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final exception = _parseError(err);
    if (exception != null) {
      err.error = exception;
    }

    super.onError(err, handler);
  }

  Exception _parseError(DioError err) {
    switch (err.type) {
      case DioErrorType.connectTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.sendTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.receiveTimeout:
        // TODO: Handle this case.
        break;
      case DioErrorType.response:
        // TODO: Handle this case.
        break;
      case DioErrorType.cancel:
        // TODO: Handle this case.
        break;
      case DioErrorType.other:
        // TODO: Handle this case.
        break;
    }
    return null;
  }
}
