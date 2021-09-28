part of 'global_bloc.dart';

class GlobalState {
  final AppState appState;

  GlobalState({
    this.appState = AppState.LOG_OUT,
  });

  GlobalState copyWith({
    AppState appState,
  }) {
    return new GlobalState(
      appState: appState ?? this.appState,
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
