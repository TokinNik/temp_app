import 'package:flutter/material.dart';
import 'package:temp_app/ui/pages/temp_login_page/temp_login_page.dart';
import 'package:temp_app/ui/router/base_router.dart';
import 'package:temp_app/utils/logger.dart';

class LoginRouter extends BaseRouter {
  LoginRouter({GlobalKey<NavigatorState>? navigationKey})
      : super(navigationKey ??
            GlobalKey<NavigatorState>(debugLabel: instanceName));

  static const String instanceName = "LoginRouter";

  @override
  void backToHome() {
    navigatorKey.currentState?.popUntil((route) {
      return route.isFirst;
    });
  }

  @override
  Route generateRoute(RouteSettings settings) {
    logD("generateRoute: ${settings.name}");
    return TempLoginPage.route();
  }

  @override
  String get initialRoute => "initialRoute";

  @override
  String get instanceDiName => "LoginRouter";
}
