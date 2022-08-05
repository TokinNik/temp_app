import 'base_router.dart';

class NavigationRoot {
  NavigationRoot({required List<BaseRouter> initialRouters})
      : _routers = initialRouters;

  List<BaseRouter> _routers = [];

  int _currentRouterIndex = 0;

  void addRouter(BaseRouter router) {
    //TODO: check same routers etc.
    if(_routers.contains(router)) return;
    _routers.add(router);
  }

  void removeRouter(BaseRouter router) {
    //TODO: check same routers etc.
    _routers.remove(router);
  }

  BaseRouter getCurrentRouter() => _routers[_currentRouterIndex];

  BaseRouter getRouterByIndex(int index) => _routers[index];

  BaseRouter switchToRouterByIndex(int index) {
    _currentRouterIndex = index;
    return getCurrentRouter();
  }
}
