
class SessionExpiredException implements Exception {
  @override
  //TODO error message localization
  String toString() => "session_expired_exception";
}

class AuthenticationFailedException implements Exception {
  @override
  //TODO error message localization
  String toString() => "authentication_failed_exception";
}