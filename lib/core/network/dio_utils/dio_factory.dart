import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:temp_app/constants/environment.dart';
import 'package:temp_app/core/network/interceptors/auth_inteceptor.dart';
import 'package:temp_app/core/network/interceptors/data_interceptor.dart';
import 'package:temp_app/data/auth/auth_holder.dart';

export 'package:dio/dio.dart' show Dio;

class DioFactory {
  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: Environment.baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 10000,
    sendTimeout: 10000,
    headers: {'accept-language': 'ru'},
  );

  static Dio buildAuthorizedClient(AuthHolder authHolder) {
    final dio = Dio(_defaultOptions);

    dio.interceptors.add(
      AuthInterceptor(authHolder, dio.interceptors.requestLock, dio),
    );

    if (Environment.isHttpLoggingEnabled) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          maxWidth: 120,
          requestHeader: true,
        ),
      );
    }

    dio.interceptors.add(DataInterceptor());
    return dio;
  }

  static Dio buildClient() {
    final dio = Dio(_defaultOptions);

    if (Environment.isHttpLoggingEnabled) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          maxWidth: 120,
          requestHeader: true,
        ),
      );
    }

    dio.interceptors.add(DataInterceptor());

    return dio;
  }
}
