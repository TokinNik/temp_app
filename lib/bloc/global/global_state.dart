part of 'global_bloc.dart';

class GlobalState {
  final AppState appState;
  BaseRouter router;
  NavigationRoot navigationRoot;

  GlobalState({
    required this.router,
    required this.navigationRoot,
    this.appState = AppState.LOG_OUT,
  });

  GlobalState copyWith({
    AppState? appState,
    BaseRouter? router,
    NavigationRoot? navigationRoot,
  }) {
    return new GlobalState(
      appState: appState ?? this.appState,
      router: router ?? this.router,
      navigationRoot: navigationRoot ?? this.navigationRoot,
    );
  }

  @override
  String toString() {
    return 'GlobalState{appState: $appState}';
  }
}

enum AppState {
  LOG_IN,
  LOG_OUT,
  //TODO: Other state
}
