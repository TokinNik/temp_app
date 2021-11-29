import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_app/bloc/base/bloc_logging.dart';
import 'package:temp_app/di/dependencies.dart';
import 'package:temp_app/utils/logger.dart';

abstract class Environment {
  static const bool _isProd = false;

  //TODO: Your api endpoint
  static const String baseUrl =
      _isProd ? 'https://prod.ru/' : 'https://test.ru/';
  static const bool isBlocLoggingEnabled = !_isProd;
  static const bool isApiLoggingEnabled = !_isProd;
  static const bool isHttpLoggingEnabled = !_isProd;

  static Future<void> init() async {
    initDependencies();

    if (isBlocLoggingEnabled) {
      Bloc.observer = LoggingBlocObserver();
    }

    // Adding smoothness for gradients
    Paint.enableDithering = true;

    // ignore: unawaited_futures
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // await Firebase.initializeApp();//todo add firebase Crashlytics or delete
    //
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //
    // await GetIt.I.get<PushNotificationsManager>().init();
    //
    // if (kDebugMode || kProfileMode) {
    //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    // }

    //TODO: Other settings...
  }

  static Future<void> recordFlutterError(
      FlutterErrorDetails flutterErrorDetails) async {
    logE(
      'RecordedFlutterError',
      e: flutterErrorDetails.exception,
      stackTrace: flutterErrorDetails.stack,
    );
    //return FirebaseCrashlytics.instance.recordFlutterError(flutterErrorDetails);//todo add firebase Crashlytics or delete
  }

  static Future<void> recordError(dynamic exception, StackTrace stack) async {
    logE('RecordedError', e: exception, stackTrace: stack);
    //return FirebaseCrashlytics.instance.recordError(exception, stack, printDetails: !_isProd);//todo add firebase Crashlytics or delete
  }
}
