class UserModel {
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? middleName;

//<editor-fold desc="Data Methods">

  UserModel({
    this.email,
    this.firstName,
    this.lastName,
    this.middleName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          middleName == other.middleName);

  @override
  int get hashCode =>
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      middleName.hashCode;

  @override
  String toString() {
    return '''UserModel{
         email: $email,
         firstName: $firstName,
         lastName: $lastName,
         middleName: $middleName,
        }''';
  }

  UserModel copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? middleName,
  }) {
    return UserModel(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      middleName: map['middleName'] as String,
    );
  }

//</editor-fold>
}
