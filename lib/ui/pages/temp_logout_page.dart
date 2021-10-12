import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_app/app.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/bloc/temp_logout/temp_logout_cubit.dart';
import 'package:temp_app/di/dependencies.dart';
import 'package:temp_app/generated/l10n.dart';
import 'package:temp_app/ui/base/base_page.dart';
import 'package:temp_app/utils/logger.dart';

TempLogoutCubit tempLogoutCubit(context) =>
    BlocProvider.of<TempLogoutCubit>(context);

class TempLogoutPage extends BasePage<TempLogoutCubit> {
  static route() {
    return MaterialPageRoute(builder: (context) => TempLogoutPage());
  }

  TempLogoutPage({Key key})
      : super(
          key: key,
          bloc: (context) => TempLogoutCubit(getIt.get()),
          state: _TempLogoutPageState(),
        );
}

class _TempLogoutPageState extends BaseState<TempLogoutState> {
  @override
  void blocListener(TempLogoutState state) {
    logD(state);
    _errorText = "";
    if (state.isSuccessful != null && state.isSuccessful) {
      globalBloc(context).add(LogInEvent());
      //TODO: show success
    } else if (state.error != null) {
      _errorText = state.error.toString();
      //TODO: handle errors
    }
  }

  String _errorText = "";

  @override
  void init() {
    super.initialBlocListener(tempLogoutCubit(context).stream);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TempLogoutCubit, TempLogoutState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Temp Logout Page"),
        ),
        body: Column(
          children: [
            Text(_errorText),
            Expanded(
              child: Center(
                child: state.isLoading
                    ? CircularProgressIndicator()
                    : TextButton(
                        onPressed: () {
                          tempLogoutCubit(context).logIn();
                        },
                        child: Text(S.current.log_in),
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
