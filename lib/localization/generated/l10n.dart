// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get _locale {
    return Intl.message(
      'en',
      name: '_locale',
      desc: '',
      args: [],
    );
  }

  /// `Сервер не отвечает. Попробуйте ещё раз.`
  String get api_error_no_server_response {
    return Intl.message(
      'Сервер не отвечает. Попробуйте ещё раз.',
      name: 'api_error_no_server_response',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка сервера (код: {httpCode})`
  String api_error_server(Object httpCode) {
    return Intl.message(
      'Ошибка сервера (код: $httpCode)',
      name: 'api_error_server',
      desc: '',
      args: [httpCode],
    );
  }

  /// `Не удалось получить детали ошибки (код: {httpCode})`
  String api_error_generic_client(Object httpCode) {
    return Intl.message(
      'Не удалось получить детали ошибки (код: $httpCode)',
      name: 'api_error_generic_client',
      desc: '',
      args: [httpCode],
    );
  }

  /// `Нет соединения с сервером. Проверьте соединение с попробуйте ещё раз.`
  String get api_error_no_server_connection {
    return Intl.message(
      'Нет соединения с сервером. Проверьте соединение с попробуйте ещё раз.',
      name: 'api_error_no_server_connection',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка сети (код: {httpCode})`
  String api_error_unknown(Object httpCode) {
    return Intl.message(
      'Ошибка сети (код: $httpCode)',
      name: 'api_error_unknown',
      desc: '',
      args: [httpCode],
    );
  }

  /// `Неверный email или пароль`
  String get wrong_email_or_password {
    return Intl.message(
      'Неверный email или пароль',
      name: 'wrong_email_or_password',
      desc: '',
      args: [],
    );
  }

  /// `LogOut`
  String get log_out {
    return Intl.message(
      'LogOut',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `LogIn`
  String get log_in {
    return Intl.message(
      'LogIn',
      name: 'log_in',
      desc: '',
      args: [],
    );
  }

  /// `NextPage`
  String get next_page {
    return Intl.message(
      'NextPage',
      name: 'next_page',
      desc: '',
      args: [],
    );
  }

  /// `Temp Next Rout Page {num}`
  String temp_next_rout_page(Object num) {
    return Intl.message(
      'Temp Next Rout Page $num',
      name: 'temp_next_rout_page',
      desc: '',
      args: [num],
    );
  }

  /// `{count, plural, one{one} two{two} few{{count} page} many{{count}mm} other{{count} ???}}`
  String number(num count) {
    return Intl.plural(
      count,
      one: 'one',
      two: 'two',
      few: '$count page',
      many: '${count}mm',
      other: '$count ???',
      name: 'number',
      desc: '',
      args: [count],
    );
  }

  /// `Change locale`
  String get change_locale {
    return Intl.message(
      'Change locale',
      name: 'change_locale',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
