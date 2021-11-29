class Token {
  final String? value;
  final DateTime? expireIn;

  Token(this.value, this.expireIn);

  bool isExpired() {
    if (expireIn == null) return false;

    return DateTime.now().isAfter(expireIn!);
  }

  bool isNearExpiration() {
    if (expireIn == null) return false;

    return DateTime.now().isAfter(expireIn!.subtract(Duration(minutes: 1)));
  }
}
