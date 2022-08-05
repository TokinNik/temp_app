import 'package:flutter/material.dart';
import 'package:temp_app/ui/router/base_router.dart';
import 'package:temp_app/utils/logger.dart';

import '../pages/temp_logout_page/temp_logout_page.dart';

class LogoutRouter extends BaseRouter {
  LogoutRouter({GlobalKey<NavigatorState>? navigationKey})
      : super(navigationKey ??
            GlobalKey<NavigatorState>(debugLabel: instanceName));

  static const String instanceName = "LogoutRouter";

  @override
  void backToHome() {
    navigatorKey.currentState?.popUntil((route) {
      return route.isFirst;
    });
  }

  @override
  Route generateRoute(RouteSettings settings) {
    logD("generateRoute: ${settings.name}");
    return TempLogoutPage.route();
  }

  @override
  String get initialRoute => "initialRoute";

  @override
  String get instanceDiName => "LogoutRouter";
}
