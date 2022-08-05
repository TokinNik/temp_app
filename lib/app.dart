import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/di/dependencies.dart';
import 'package:temp_app/ui/pages/home/home_page.dart';
import 'package:temp_app/ui/pages/temp_login_page/temp_login_page.dart';
import 'package:temp_app/ui/pages/temp_logout_page/temp_logout_page.dart';
import 'package:temp_app/ui/router/login_router.dart';
import 'package:temp_app/ui/router/logout_router.dart';

import 'constants/colors.dart';
import 'localization/generated/l10n.dart';

GlobalBloc globalBloc(context) => BlocProvider.of<GlobalBloc>(context);

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  late GlobalBloc _globalBloc;


  @override
  void initState() {
    super.initState();
    _globalBloc = GlobalBloc(
      getIt.get(instanceName: LogoutRouter.instanceName),
      getIt.get(instanceName: LoginRouter.instanceName),
    );
  }

  rStateListener() {
    setState(() {
      //rebuild
    });
  }

  @override
  void dispose() {
    globalBloc(context).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GlobalBloc>(
      create: (BuildContext context) => _globalBloc,
      child: BlocBuilder<GlobalBloc, GlobalState>(
        bloc: _globalBloc,
        builder: (context, state) {
          return MaterialApp(
            home: Stack(
              children: [
                MaterialApp(
                  localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  //  locale: Locale('en', ''), //TODO: change locale if need
                  navigatorKey: state.navigationRoot.getCurrentRouter().navigatorKey,
                  onGenerateRoute: state.navigationRoot.getCurrentRouter().generateRoute,
                  initialRoute: state.navigationRoot.getCurrentRouter().initialRoute,
                  navigatorObservers: [NavigationHistoryObserver()],
                  home: Container(
                    color: AppColors.white,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                HomePage(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(GlobalState state) {
    switch (state.appState) {
      case AppState.LOG_IN:
        return TempLoginPage();
      case AppState.LOG_OUT:
        return TempLogoutPage();
    }
  }
}
