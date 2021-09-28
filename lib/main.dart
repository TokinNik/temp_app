import 'package:flutter/material.dart';
import 'package:temp_app/constants/environment.dart';

import 'app.dart';

void main() async {
  await Environment.init();

  runApp(App());
}
