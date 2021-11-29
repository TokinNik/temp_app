import 'user_model.dart';

class LoginModel {
  final UserModel? user;
  final String? accessToken;

//<editor-fold desc="Data Methods">

  LoginModel({
    this.user,
    this.accessToken,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoginModel &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          accessToken == other.accessToken);

  @override
  int get hashCode => user.hashCode ^ accessToken.hashCode;

  @override
  String toString() {
    return '''LoginModel{
         user: $user,
         accessToken: $accessToken,
        }''';
  }

  LoginModel copyWith({
    UserModel? user,
    String? accessToken,
  }) {
    return LoginModel(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'accessToken': accessToken,
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      user: map['user'] as UserModel,
      accessToken: map['accessToken'] as String,
    );
  }

//</editor-fold>
}
