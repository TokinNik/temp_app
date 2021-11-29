// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(httpCode) =>
      "Не удалось получить детали ошибки (код: ${httpCode})";

  static String m1(httpCode) => "Ошибка сервера (код: ${httpCode})";

  static String m2(httpCode) => "Ошибка сети (код: ${httpCode})";

  static String m3(count) =>
      "${Intl.plural(count, one: 'one', two: 'two', few: '${count} page', many: '${count}mm', other: '${count} ???')}";

  static String m4(num) => "Temp Next Rout Page ${num}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "_locale": MessageLookupByLibrary.simpleMessage("en"),
        "api_error_generic_client": m0,
        "api_error_no_server_connection": MessageLookupByLibrary.simpleMessage(
            "Нет соединения с сервером. Проверьте соединение с попробуйте ещё раз."),
        "api_error_no_server_response": MessageLookupByLibrary.simpleMessage(
            "Сервер не отвечает. Попробуйте ещё раз."),
        "api_error_server": m1,
        "api_error_unknown": m2,
        "change_locale": MessageLookupByLibrary.simpleMessage("Change locale"),
        "log_in": MessageLookupByLibrary.simpleMessage("LogIn"),
        "log_out": MessageLookupByLibrary.simpleMessage("LogOut"),
        "next_page": MessageLookupByLibrary.simpleMessage("NextPage"),
        "number": m3,
        "temp_next_rout_page": m4,
        "wrong_email_or_password":
            MessageLookupByLibrary.simpleMessage("Неверный email или пароль")
      };
}
