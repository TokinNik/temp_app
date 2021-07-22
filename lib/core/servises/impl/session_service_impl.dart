import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:temp_app/core/data/session.dart';
import 'package:temp_app/core/data/token.dart';
import 'package:temp_app/core/dio/errors/error_unwrapper.dart';
import 'package:temp_app/core/servises/session_service.dart';
import 'package:temp_app/utils/logger.dart';

class SessionServiceImpl with ErrorUnWrapper implements SessionService {
  final Dio dio;
  var prefs = FlutterSecureStorage();

  SessionServiceImpl(this.dio);

  Future<Session> getSession() async {
    try {
      var rawSession = await prefs.read(key: "SESSION");
      Session session = sessionFromJson(rawSession);
      return session;
    } catch (e) {
      return null;
    }
  }

  Future<void> setSession(Session session) async {
    await prefs.write(key: "SESSION", value: sessionToJson(session));
  }

  Future<void> clearSession() async {
    await prefs.deleteAll();
  }

  @override
  Future<bool> checkToken(Token token) => run(() {
        // TODO: implement checkToken
        return Future.delayed(Duration(seconds: 1), () => true);
      });

  @override
  Future<Token> refreshToken() => run(() {
        {
          // TODO: implement refreshToken
          return Future.delayed(
            Duration(seconds: 1),
            () => Token(
              value: "token",
              expireIn: DateTime.now().add(
                Duration(minutes: 1),
              ),
            ),
          );
        }
      });

  @override
  Future<void> onTokenExpired() => run(() {
        {
          // TODO: implement onTokenExpired
          return Future.delayed(Duration(seconds: 1), () {
            logD("onTokenExpired");
          });
        }
      });
}

Session sessionFromJson(String str) => Session.fromJson(json.decode(str));

String sessionToJson(Session data) => json.encode(data.toJson());
