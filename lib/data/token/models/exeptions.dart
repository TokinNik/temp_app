class SessionExpiredException implements Exception {
  @override
  String toString() =>
      'Время сессии истекло. Войдите ещё раз, чтобы продолжить работу';
}

// class AuthenticationFailedException implements Exception {
//   @override
//   String toString() => 'Неудалось авторизоваться. Попробуйте ещё раз';
// }

// class ValidationError implements Exception {
//   final Map<String?, String> fields = {};
//
//   ValidationError();
//
//   @override
//   String toString() => 'ValidationError($fields)';
//
//   void add(String? field, String code, [String? message]) {
//     fields[field] = localizeApiErrorMessage(code, message);
//   }
// }
