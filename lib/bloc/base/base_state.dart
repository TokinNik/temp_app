import 'package:equatable/equatable.dart';

abstract class BasicState extends Equatable {
  @override
  List<Object?> get props => [hashCode];

  @override
  String toString() => '$runtimeType($props)';
}
