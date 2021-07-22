part of 'global_bloc.dart';

class GlobalState extends Equatable {
  final AppState appState;

  GlobalState({
    this.appState = AppState.LOG_OUT,
  });

  @override
  List<Object> get props => [
        appState,
      ];

  GlobalState copyWith({
    AppState appState,
  }) {
    if ((appState == null || identical(appState, this.appState))) {
      return this;
    }

    return new GlobalState(
      appState: appState ?? this.appState,
    );
  }
}

enum AppState {
  LOG_IN,
  LOG_OUT,
  //TODO: Other state
}
