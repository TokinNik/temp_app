import 'package:bloc/bloc.dart';
import 'package:temp_app/bloc/base/base_api_calls.dart';
import 'package:temp_app/bloc/base/base_state.dart';
import 'package:temp_app/core/servises/session_service.dart';
import 'package:temp_app/utils/logger.dart';

part 'temp_logout_state.dart';

class TempLogoutCubit extends Cubit<TempLogoutState> {
  TempLogoutCubit(this.sessionService) : super(TempLogoutState());

  final SessionService sessionService;

  logIn() async {
    simpleApiCall<TempLogoutState>(
      this,
      sessionService.refreshToken,
      onSuccess: (result) {
        var newToken = result;
        logD(newToken);
      },
      onError: () {
        //TODO: do on error
      },
      showSuccess: true,
    );
  }
}
