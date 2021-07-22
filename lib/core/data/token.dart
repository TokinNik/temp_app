class Token {
  static const int NEAR_EXPIRE_RANGE_IN_MINUTES = 1;

  final String value;
  final DateTime expireIn;

  Token({
    this.value,
    this.expireIn,
  });

  bool isExpired() {
    if (expireIn == null) return false;

    return DateTime.now().isAfter(expireIn);
  }

  bool isNearExpiration() {
    if (expireIn == null) return false;

    return DateTime.now().isAfter(
      expireIn.subtract(
        Duration(
          minutes: NEAR_EXPIRE_RANGE_IN_MINUTES,
        ),
      ),
    );
  }

  factory Token.fromMap(Map<String, dynamic> map) {
    return new Token(
      value: map['value'] as String,
      expireIn: map['expireIn'] as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'value': this.value,
      'expireIn': this.expireIn,
    } as Map<String, dynamic>;
  }

  @override
  String toString() {
    return 'Token{value: $value, expireIn: $expireIn}';
  }
}
