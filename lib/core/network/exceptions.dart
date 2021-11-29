import 'package:temp_app/localization/generated/l10n.dart';

abstract class ApiException implements Exception {
  final int? httpCode;

  ApiException(this.httpCode);
}

class ClientApiException extends ApiException {
  final String? message;

  ClientApiException(int? httpCode, {this.message}) : super(httpCode);

  @override
  String toString() => message ?? S.current.api_error_generic_client(httpCode!);
}

class BadRequestClientApiException extends ClientApiException {
  final Map<String, dynamic>? data;

  BadRequestClientApiException(int? httpCode, {this.data})
      : super(httpCode, message: data.toString());
}

class UnauthorizedClientApiException extends ClientApiException {
  UnauthorizedClientApiException({int? httpCode}) : super(httpCode);
}

class NotFoundClientApiException extends ClientApiException {
  NotFoundClientApiException(int? httpCode) : super(httpCode);
}

class ServerApiException extends ApiException {
  ServerApiException(int? httpCode) : super(httpCode);

  @override
  String toString() => S.current.api_error_server(httpCode!);
}

class UnknownApiException extends ApiException {
  UnknownApiException(int? httpCode) : super(httpCode);

  @override
  String toString() => S.current.api_error_unknown(httpCode!);
}

class ServerConnectionException implements Exception {
  @override
  String toString() => S.current.api_error_no_server_connection;
}

class ServerTimeoutException implements Exception {
  @override
  String toString() => S.current.api_error_no_server_response;
}

class RequestCancelledException implements Exception {
  final String? message;

  RequestCancelledException({this.message});

  @override
  String toString() => S.current.api_error_no_server_response;
}

class WrongEmailOrPasswordException implements Exception {
  @override
  String toString() => S.current.wrong_email_or_password;
}
