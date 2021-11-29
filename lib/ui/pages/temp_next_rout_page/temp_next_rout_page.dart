import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/localization/generated/l10n.dart';

GlobalBloc _globalBloc(context) => BlocProvider.of<GlobalBloc>(context);

class TempNextRoutPage extends StatefulWidget {
  static route(int num) {
    return MaterialPageRoute(
      builder: (context) => TempNextRoutPage(num),
    );
  }

  TempNextRoutPage(this.num, {Key? key})
      : super(
          key: key,
        );

  final num;

  @override
  State<StatefulWidget> createState() => _TempNextRoutPageState();
}

class _TempNextRoutPageState extends State<TempNextRoutPage> {
  _TempNextRoutPageState();

  @override
  Widget build(BuildContext context) {
    var s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.temp_next_rout_page(s.number(widget.num))),
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
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(s.log_out),
                ),
                SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(TempNextRoutPage.route(widget.num + 1));
                  },
                  child: Text(s.next_page),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
