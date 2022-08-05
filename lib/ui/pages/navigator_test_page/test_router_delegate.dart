import 'package:flutter/material.dart';

import 'test_1_page.dart';
import 'test_2_page.dart';

class TestRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  TestRouterDelegate() : navigatorKey = GlobalKey();

  final RouterState state = RouterState();

  bool taped = false;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  void addListener(VoidCallback listener) {
    state.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: (route, result) => route.didPop(result),
      pages: [
        TestPage1(onTap: () {
          // taped = true;
          state.taped = true;
          print("tap1 ${state.taped}");
        }),
        if (state.taped)
          TestPage2(onTap: () {
            // taped = false;
            state.taped = false;
            print("tap2 ${state.taped}");
          }),
      ],
    );
  }

  @override
  Future<bool> popRoute() {
    //todo
    return Future.value(true);
  }

  @override
  void removeListener(VoidCallback listener) {
    state.removeListener(listener);
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    //todo
    return Future.value(null);
  }
}

class RouterState extends ChangeNotifier {
  bool get taped => _taped;
  bool _taped = false;

  set taped(bool value) {
    _taped = value;
    notifyListeners();
  }
}
