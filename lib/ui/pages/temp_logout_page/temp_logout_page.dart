import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_app/app.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/ui/pages/temp_logout_page/bloc/temp_logout_cubit.dart';
import 'package:temp_app/di/dependencies.dart';
import 'package:temp_app/localization/generated/l10n.dart';
import 'package:temp_app/utils/logger.dart';

TempLogoutCubit tempLogoutCubit(context) =>
    BlocProvider.of<TempLogoutCubit>(context);

class TempLogoutPage extends StatelessWidget {
  static route() {
    return MaterialPageRoute(builder: (context) => TempLogoutPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TempLogoutCubit(getIt.get()),
      child: TempLogoutScreen(),
    );
  }
}

class TempLogoutScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TempLogoutPageState();
}

class _TempLogoutPageState extends State<TempLogoutScreen> {

  void blocListener(BuildContext context, TempLogoutState state) {
    logD(state);
    if (state.isSuccessful) {
      globalBloc(context).add(LogInEvent());
      //TODO: show success
    } else if (state.error != null) {
      //TODO: handle errors
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TempLogoutCubit, TempLogoutState>(
      builder: _buildScreen,
      listener: blocListener,
    );
  }

  Widget _buildScreen(BuildContext context, TempLogoutState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Temp Logout Page"),
      ),
      body: Column(
        children: [
          Text(state.error.toString()),
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
  }
}
