import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  var prefs = FlutterSecureStorage();

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
}

Session sessionFromJson(String str) => Session.fromJson(json.decode(str));

String sessionToJson(Session data) => json.encode(data.toJson());

class Session {
  String loginEmail;
  int id;
  String accessToken;
  String refreshToken;

  Session({
    this.loginEmail,
    this.id,
    this.accessToken,
    this.refreshToken,
  });

  Session copyWith({
    String loginEmail,
    int id,
    String accessToken,
    String refreshToken,
  }) {
    return new Session(
      loginEmail: loginEmail ?? this.loginEmail,
      id: id ?? this.id,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  String toString() {
    return 'Session{loginEmail: $loginEmail, id: $id, accessToken: $accessToken, refreshToken: $refreshToken}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          runtimeType == other.runtimeType &&
          loginEmail == other.loginEmail &&
          id == other.id &&
          accessToken == other.accessToken &&
          refreshToken == other.refreshToken);

  @override
  int get hashCode =>
      loginEmail.hashCode ^
      id.hashCode ^
      accessToken.hashCode ^
      refreshToken.hashCode;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        loginEmail: json["loginEmail"],
        accessToken: json["accessToken"],
        id: json["externalId"],
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "loginEmail": loginEmail,
        "externalId": id,
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}
