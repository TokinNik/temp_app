import 'package:dio/dio.dart';

extension ResponseErrors on Response {
  bool get isClientError => statusCode! >= 400 && statusCode! < 500;
  bool get isBadRequestError => statusCode == 400;
  bool get isUnauthorizedError => statusCode == 401;
  bool get isNotFoundError => statusCode == 404;
  bool get isServerError => statusCode! >= 500 && statusCode! < 600;
}
