import 'package:bloc/bloc.dart';
import 'package:temp_app/bloc/base/base_state.dart';
import 'package:temp_app/core/network/api_errors/api_errors.dart';
import 'package:temp_app/data/login/models/network/login_request.dart';
import 'package:temp_app/domain/login/login_usecase.dart';
import 'package:temp_app/utils/logger.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._loginUseCase) : super(HomeState());

  final LoginUseCase _loginUseCase;

  logIn() async {
    emit(state.copyWith(isLoading: true));
    try {
      var request = LoginRequest("email", "password");
      var result = await _loginUseCase.call(request);
      var newToken = result;
      logD(newToken);
      emit(state.copyWith(isSuccessful: true));
    } on ApiError catch (e) {
      //todo Error
    }
    emit(state.copyWith(isLoading: false));
  }
}
