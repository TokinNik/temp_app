import 'package:temp_app/utils/logger.dart';

extension IterableExtension<T> on Iterable<T> {
  printAll() {
    this.forEach((element) {
      logD("$element");
    });
  }

  void forEachIndexed(void Function(T e, int i) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }

  Iterable<E> mapIndexed<E>(E Function(T e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  get tryLength => (this?.length ?? 0);

  get tryFirst => ((this?.length ?? 0) > 0 ? this?.first : null);
}

extension StringExtension on String {
  String capitalize() =>
      this.replaceRange(0, 1, this.substring(0, 1).toUpperCase());

  String capitalizeAll() =>
      this.split(" ").map((e) => e.capitalize()).join(" ");

  bool isNullOrEmpty() => (this == null || this.isEmpty);
}
