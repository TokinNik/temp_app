import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'temp_event.dart';
part 'temp_state.dart';

class TempBloc extends Bloc<TempEvent, TempState> {
  TempBloc() : super(TempState());

  @override
  Stream<TempState> mapEventToState(
    TempEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
