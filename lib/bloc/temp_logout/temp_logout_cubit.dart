import 'package:bloc/bloc.dart';
import 'package:temp_app/utils/logger.dart';

part 'temp_logout_state.dart';

class TempLogoutCubit extends Cubit<TempLogoutState> {
  TempLogoutCubit() : super(TempLogoutState());

  logIn() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(Duration(seconds: 2));
    emit(state.copyWith(
      isLoading: false,
      isSuccessful: true,
    ));
    emit(state.copyWith(isSuccessful: false));
  }




}
