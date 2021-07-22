import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/ui/pages/temp_login_page.dart';
import 'package:temp_app/ui/pages/temp_logut_page.dart';

GlobalBloc globalBloc(context) => BlocProvider.of<GlobalBloc>(context);

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  GlobalBloc _globalBloc;

  @override
  void initState() {
    super.initState();
    _globalBloc = GlobalBloc();
  }

  @override
  void dispose() {
    _globalBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (BuildContext context) => _globalBloc,
        child: BlocBuilder<GlobalBloc, GlobalState>(
          bloc: _globalBloc,
          builder: (context, state) {
            switch (state.appState) {
              case AppState.LOG_IN:
                return TempLoginPage();
                break;
              case AppState.LOG_OUT:
                return TempLogoutPage();
                break;
            }
            return Center(
              child: Text("Unknown app state"),
            );
          },
        ),
      ),
    );
  }
}
