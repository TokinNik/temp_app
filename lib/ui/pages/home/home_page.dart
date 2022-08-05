import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:temp_app/app.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/constants/colors.dart';
import 'package:temp_app/di/dependencies.dart';
import 'package:temp_app/localization/generated/l10n.dart';
import 'package:temp_app/utils/logger.dart';

import 'bloc/home_cubit.dart';

HomeCubit tempLogoutCubit(context) => BlocProvider.of<HomeCubit>(context);

class HomePage extends StatelessWidget {
  static route() {
    return MaterialPageRoute(builder: (context) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(getIt.get()),
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  void blocListener(BuildContext context, HomeState state) {
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
    NavigationHistoryObserver()
        .historyChangeStream
        .listen((change) => logD("NavChange: \n${change.action}\n${change.newRoute}\n${change.oldRoute}\n"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      builder: _buildScreen,
      listener: blocListener,
    );
  }

  Widget _buildScreen(BuildContext context, HomeState state) {
    return Container(
      color: AppColors.black,
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              globalBloc(context).add(LogInEvent());
            },
            child: Text(S.current.log_in),
          ),
          TextButton(
            onPressed: () {
              globalBloc(context).add(LogOutEvent());
            },
            child: Text(S.current.log_out),
          ),
        ],
      ),
    );
  }
}
