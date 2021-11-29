import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:temp_app/constants/environment.dart';

import 'app.dart';

void main() async {
  await Environment.init();

  FlutterError.onError = Environment.recordFlutterError;

  Isolate.current.addErrorListener(RawReceivePort(
    (pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await Environment.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    },
  ).sendPort);

  runZonedGuarded(
    () => runApp(App()),
    Environment.recordError,
  );
}
