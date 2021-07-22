import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'temp_logout_state.dart';

class TempLogoutCubit extends Cubit<TempLogoutState> {
  TempLogoutCubit() : super(TempLogoutState());

  logIn(){
    print("LogIn");
  }

}
