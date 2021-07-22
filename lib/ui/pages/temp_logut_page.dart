import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_app/app.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/bloc/temp_logout/temp_logout_cubit.dart';
import 'package:temp_app/ui/base/base_page.dart';

TempLogoutCubit tempLogoutCubit(context) =>
    BlocProvider.of<TempLogoutCubit>(context);

class TempLogoutPage extends BasePage<TempLogoutCubit> {
  TempLogoutPage({Key key})
      : super(
          key: key,
          bloc: (context) => TempLogoutCubit(),
          state: _TempLogoutPageState(),
        );
}

class _TempLogoutPageState extends State<BaseStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TempLogoutCubit, TempLogoutState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Temp Logout Page"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    tempLogoutCubit(context).logIn();
                    globalBloc(context).add(LogInEvent());
                  },
                  child: Text("LogIn"),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
