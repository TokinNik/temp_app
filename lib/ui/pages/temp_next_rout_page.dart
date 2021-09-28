import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/ui/base/base_page.dart';

GlobalBloc _globalBloc(context) => BlocProvider.of<GlobalBloc>(context);

class TempNextRoutPage extends BasePage {
  static route(int num) {
    return MaterialPageRoute(
      builder: (context) => TempNextRoutPage(num),
    );
  }

  TempNextRoutPage(int num, {Key key})
      : super(
          key: key,
          state: _TempNextRoutPageState(num),
        );
}

class _TempNextRoutPageState extends BaseState<BaseStatefulWidget> {
  _TempNextRoutPageState(this.num);

  final int num;

  @override
  void blocListener(BaseStatefulWidget state) {
    // TODO: implement blocListener
  }

  @override
  void init() {
    // TODO: implement init
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Temp Next Rout Page ($num)"),
      ),
      body: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    _globalBloc(context).add(LogOutEvent());
                    // Navigator.of(context).pop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text("LogOut"),
                ),
                SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(TempNextRoutPage.route(num + 1));
                  },
                  child: Text("NextPage"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
