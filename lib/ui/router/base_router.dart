import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as m;
import 'package:temp_app/constants/colors.dart';
import 'package:temp_app/utils/logger.dart';

abstract class BaseRouter {
  final GlobalKey<NavigatorState> navigatorKey;

  BaseRouter(this.navigatorKey) {
    logD("BaseRouter: $navigatorKey");
  }

  BuildContext? get _navigatorContext =>
      navigatorKey.currentState?.overlay?.context;

  String get initialRoute;

  String get instanceDiName;

  Future<T?> navigateTo<T>(String route, {Object? arguments}) =>
      navigatorKey.currentState!.pushNamed(route, arguments: arguments);

  Future<T?> navigateToRoute<T>(Route<T> route) =>
      navigatorKey.currentState!.push(route);

  Future<T?> navigateAndReplaceTo<T>(String route, {Object? arguments}) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!
          .pushReplacementNamed(route, arguments: arguments);
    } else {
      return Future.value(null);
    }
  }

  void pop<T extends Object>([T? result]) =>
      navigatorKey.currentState!.pop(result);

  void popWithContext<T extends Object>(BuildContext context, [T? result]) =>
      Navigator.pop(context, result);

  Route<dynamic> generateRoute(RouteSettings settings);

  void backToHome();

  @protected
  Future<T?> showMaterialDialog<T>(
    WidgetBuilder builder, {
    bool barrierDismissible = true,
  }) {
    var context = _navigatorContext;
    if (context != null) {
      return m.showDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible,
        barrierColor: AppColors.transparent,
      );
    } else {
      return Future.value(null);
    }
  }

  @protected
  Future<T?> showDialog<T>(
    WidgetBuilder builder, {
    bool barrierDismissible = true,
    int restartCount = 0,
  }) async {
    var context = _navigatorContext;
    if (context != null) {
      return showCupertinoDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible,
      );
    } else {
      if (restartCount < 10) {
        await Future.delayed(Duration(milliseconds: 200));
        logD("Dialog restert $restartCount");
        showDialog(
          builder,
          barrierDismissible: barrierDismissible,
          restartCount: restartCount + 1,
        );
      } else {
        return Future.value(null);
      }
    }
  }

  @protected
  Future<T?> showGeneralDialog<T>(
    WidgetBuilder builder, {
    bool barrierDismissible = true,
    int restartCount = 0,
  }) async {
    var context = _navigatorContext;
    if (context != null) {
      return m.showGeneralDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        transitionBuilder: (context, anim1, anim2, child) {
          logD(anim1.value);
          final curvedValue = Curves.fastOutSlowIn.transform(anim1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(-curvedValue * 200, 0.0, 0.0),
            child: builder.call(context),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return Transform.translate(
            offset: Offset(100, 0),
            child: builder.call(context),
          );
        },
      );
    } else {
      if (restartCount < 10) {
        await Future.delayed(Duration(milliseconds: 200));
        showDialog(
          builder,
          barrierDismissible: barrierDismissible,
          restartCount: restartCount + 1,
        );
      } else {
        return Future.value(null);
      }
    }
  }

  @protected
  Future<T?> showModalBottomSheet<T>(
    WidgetBuilder builder, {
    bool barrierDismissible = true,
  }) {
    var context = _navigatorContext;
    if (context != null) {
      return showCupertinoModalPopup<T>(
        context: context,
        builder: builder,
      );
    } else {
      return Future.value(null);
    }
  }
}
