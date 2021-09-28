abstract class ApiErrorException implements Exception {}

class SessionExpiredException implements ApiErrorException {
  @override
  //TODO error message localization
  String toString() => "session_expired_exception";
}

class AuthenticationFailedException implements ApiErrorException {
  @override
  //TODO error message localization
  String toString() => "authentication_failed_exception";
}

class ConnectionLostException implements ApiErrorException {
  @override
  //TODO error message localization
  String toString() => "connection_lost_exception";
}
