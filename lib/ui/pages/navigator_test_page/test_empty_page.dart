import 'package:flutter/material.dart';

class TestEmpty extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => SizedBox.shrink(),
    );
  }
}