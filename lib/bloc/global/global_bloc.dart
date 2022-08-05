import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:temp_app/ui/router/login_router.dart';
import 'package:temp_app/ui/router/logout_router.dart';
import 'package:temp_app/ui/router/navigation_root.dart';

import '../../ui/router/base_router.dart';

part 'global_event.dart';

part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc(
    this._logoutRouter,
    this._loginRouter,
  ) : super(
          GlobalState(
            router: _logoutRouter,
            navigationRoot: NavigationRoot(
              initialRouters: [
                _logoutRouter,
              ],
            ),
          ),
        );

  final LogoutRouter _logoutRouter;
  final LoginRouter _loginRouter;

  @override
  Stream<GlobalState> mapEventToState(
    GlobalEvent event,
  ) async* {
    if (event is LogInEvent) {
      state.navigationRoot.addRouter(_loginRouter);
      state.navigationRoot.switchToRouterByIndex(1);
      yield state.copyWith(
        appState: AppState.LOG_IN,
      );
    } else if (event is LogOutEvent) {
      // state.navigationRoot.removeRouter(_loginRouter);
      state.navigationRoot.switchToRouterByIndex(0);
      yield state.copyWith(
        appState: AppState.LOG_OUT,
      );
    }
  }
}
