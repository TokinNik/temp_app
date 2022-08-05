class Pair<F, S> {
  final F first;
  final S second;

  Pair(this.first, this.second);

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }
}

class Triple<F, S, T> {
  final F first;
  final S second;
  final T third;

  Triple(this.first, this.second, this.third);

  @override
  String toString() {
    return 'Triple{first: $first, second: $second, third: $third}';
  }
}
