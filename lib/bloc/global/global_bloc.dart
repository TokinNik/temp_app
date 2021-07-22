import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'global_event.dart';

part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(GlobalState());

  @override
  Stream<GlobalState> mapEventToState(
    GlobalEvent event,
  ) async* {
    if (event is LogInEvent) {
      yield state.copyWith(
        appState: AppState.LOG_IN,
      );
    } else if (event is LogOutEvent) {
      yield state.copyWith(
        appState: AppState.LOG_OUT,
      );
    }
  }
}
